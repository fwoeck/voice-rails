app.setupPhone = ->

  return unless phone.isWebRTCAvailable
  return unless app.loadLocalKey('useWebRtc')

  data =
    login:    env.sipAgent
    password: env.sipSecret

  phone.notify = (call) ->
    console.log('SIP notify call:', call) if env.debug

  phone.notifyAddCall = (call) ->
    console.log('SIP add call:', call) if env.debug

    if call.incoming
      env.callDialogActive = true
      name = app.sanitizeCallerName(call)
      app.takeIncomingCall(call, name)

  phone.notifyRemoveCall = (call) ->
    console.log('SIP remove call:', call) if env.debug
    if env.callDialogActive
      env.callDialogActive = false
      Voice.dialogController.cancel()

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
      app.dialog(i18n.dialog.lost_server_conn, 'error').then (->
        app.logout()
      )

  env.sseSource.onmessage = (event) ->
    Ember.run ->
      data = JSON.parse(event.data)
      console.log('SSE message:', data) if env.debug

      app.parseIncomingData(data)
      if env.railsEnv == 'test' && !data.servertime
        env.messages.push(data)
