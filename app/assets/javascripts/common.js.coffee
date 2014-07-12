window.app = {

  noLogin: ->
    env.userId.length == 0


  setupPhone: ->
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


  setupInterface: ->
    ($ '#agent_overview > h5').click ->
      ($ '#call_queue').toggleClass('expanded')

    ($ '#my_settings > h5').click ->
      ($ '#my_settings').toggleClass('expanded')
      ($ '#call_queue').toggleClass('lifted')

    ($ '#call_queue > h5').click ->
      ($ '#call_queue').addClass('expanded').addClass('lifted')
      ($ '#my_settings').removeClass('expanded')

    ($ document).on 'click', '#my_settings label', (el) -> ($ el.target).siblings('input').click()


  updateUserFrom: (data) ->
    @updateRecordFrom(data, 'user', Voice.User)


  updateCallFrom: (data) ->
    @updateRecordFrom(data, 'call', Voice.Call)


  createMessageFrom: (data) ->
    @updateRecordFrom(data, 'chat_message', Voice.ChatMessage)


  updateRecordFrom: (data, name, klass) ->
    obj = Voice.store.getById(name, data[name].id)
    if obj
      Voice.aS.normalizeAttributes(klass, data[name])
      Ember.keys(data[name]).forEach (key) ->
        val = data[name][key]
        val = new Date(val) if val && key.match(/At$/)

        # Caution! We never update fields to falsy values:
        #
        if key != 'id' && val && Ember.compare(obj.get(key), val)
          obj.set(key, val)
    else
      Voice.store.pushPayload(name, data)


  setupSSE: ->
    params = "?user_id=#{env.userId}&rails_env=#{env.railsEnv}&token=#{env.sessionToken}"
    env.sseSource = new EventSource('/events' + params)

    env.sseSource.onopen = (event) ->
      console.log(new Date, 'Opened SSE connection.') if env.debug

    env.sseSource.onerror = (event) ->
      console.log(new Date, 'SSE connection error', event)
      window.setTimeout app.setupSSE, 1000
      env.sseSource.close()

    env.sseSource.onmessage = (event) ->
      data = JSON.parse(event.data)
      console.log('SSE message:', data) if env.debug

      if data.user
        app.updateUserFrom(data)
      else if data.call
        app.updateCallFrom(data)
      else if data.chat_message
        app.createMessageFrom(data)

      if env.railsEnv == 'test' && !data.servertime
        env.messages.push(data)


  focusDefaultTabindex: ->
    ($ '#hidden_tabindex input').focus()


  hideTooltips: ->
    new Ember.RSVP.Promise (resolve, reject) ->
      ($ 'body > span.tooltip').trigger('touchstart.fndtn.tooltip')
      ($ ':animated').promise().done -> resolve()


  strippedEmail: (email) ->
    email.match(env.abideOptions.patterns.email)?[0].toLowerCase()


  resetAbide: ->
    ($ 'form[data-abide]').parent().unbind().foundation()


  showDefaultError: (message) ->
    app.dialog(message, 'error').then (->), (->)


  showDefaultMessage: (message) ->
    app.dialog(message, 'message').then (->), (->)


  dialog: (message, type='question', textYes='Ok', textNo='Cancel', text, format) ->
    new Ember.RSVP.Promise (resolve, reject) ->
      dialog = Ember.Object.create
        message: message
        textYes: textYes
        resolve: resolve
        reject:  reject
        textNo:  textNo
        format:  format
        text:    text
        type:    type

      Voice.set 'dialogContent', dialog

}
