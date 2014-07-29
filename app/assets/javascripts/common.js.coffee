window.app = {

  resetServerTimer: ->
    window.clearTimeout(env.serverTimeout) if env.serverTimeout
    env.serverTimeout = window.setTimeout (->
      app.dialog('Sorry, we stopped receiving messages &mdash;<br />please open just one app window at a time.', 'error').then (->
        app.logout()
      )
    ), 12000


  logout: ->
    phone.app.logoff() unless Modernizr.touch
    $.post('/auth/logout', {'_method': 'DELETE'}). then (->
      window.location.reload()
    )


  noLogin: ->
    env.userId.length == 0


  setupInterface: ->
    ($ '#agent_overview > h5').click ->
      app.hideTooltips()
      if ($ 'input[name=agent_search]').is(':focus')
        ($ '#call_queue').removeClass('expanded')
      else
        ($ '#call_queue').toggleClass('expanded')

    ($ '#my_settings > h5').click ->
      app.hideTooltips()
      ($ '#my_settings').toggleClass('expanded')
      ($ '#call_queue').toggleClass('lifted')

    ($ '#call_queue > h5').click ->
      app.hideTooltips()
      ($ '#call_queue').addClass('expanded').addClass('lifted')
      ($ '#my_settings').removeClass('expanded')

    ($ document).on 'click', '#my_settings label', (el) ->
      ($ el.target).siblings('input').click()


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
      if name == 'call' && data[name].hungup
        obj.deleteRecord()
      else
        @updateKeysFromData(obj, name, data)
    else
      Voice.store.pushPayload(name, data)


  updateKeysFromData: (obj, name, data) ->
    Ember.keys(data[name]).forEach (key) =>
      val = data[name][key]
      val = new Date(val) if val && key.match(/At$/)
      obj.set(key, val) if @valueNeedsUpdate(obj, key, val)


  valueNeedsUpdate: (obj, key, val) ->
    key != 'id' && (val || typeof val == 'string') &&
      Ember.compare(obj.get(key), val)


  focusDefaultTabindex: ->
    ($ '#hidden_tabindex input').focus()


  hideTooltips: ->
    new Ember.RSVP.Promise (resolve, reject) ->
      ($ '.has-tip').trigger('mouseout')
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
