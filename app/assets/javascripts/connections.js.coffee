app.setupPhone = ->

  data =
    login:    env.sipAgent
    password: env.sipSecret

  phone.notify = (call) ->
    console.log('SIP notify call:', call) if env.debug

  phone.notifyAddCall = (call) ->
    console.log('SIP add call:', call) if env.debug
    env.callDialogActive = true

    app.dialog("You have an incoming call from<br />#{call.visibleNameCaller}", 'question', 'Answer', 'Requeue').then ( ->
      env.callDialogActive = false
      phone.app.answer(call.id, false)
    ), ( ->
      env.callDialogActive = false
      phone.app.hangup(call.id)
    )

  phone.notifyRemoveCall = (call) ->
    console.log('SIP remove call:', call) if env.debug
    if env.callDialogActive
      env.callDialogActive = false
      Voice.dialogController.clear()

  phone.notifyRegistered = (session) ->
    console.log('SIP registered:', session) if env.debug

  phone.app.login(data)
  unless phone.app.hasAccessToAudio()
    phone.app.getAccessToAudio()



app.setupSSE = ->

  params = "?user_id=#{env.userId}&rails_env=#{env.railsEnv}&token=#{env.sessionToken}"
  env.sseSource = new EventSource('/events' + params)

  env.sseSource.onopen = (event) ->
    env.sseErrors = 0
    console.log(new Date, 'Opened SSE connection.') if env.debug

  env.sseSource.onerror = (event) ->
    console.log(new Date, 'SSE connection error', event)
    env.sseErrors += 1
    env.sseSource.close()

    if env.sseErrors < 4
      window.setTimeout app.setupSSE, 1000
    else
      app.dialog('Sorry, we lost our connection to the server &mdash;<br />please check your network and try to re-login.', 'error').then (->
        app.logout()
      )

  env.sseSource.onmessage = (event) ->
    data = JSON.parse(event.data)
    console.log('SSE message:', data) if env.debug

    if data.user
      app.updateUserFrom(data)
    else if data.call
      app.updateCallFrom(data)
    else if data.chat_message
      app.createMessageFrom(data)
    else if data.servertime
      app.resetServerTimer()

    if env.railsEnv == 'test' && !data.servertime
      env.messages.push(data)
