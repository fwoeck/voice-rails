window.app = {

  compileAvailabilityPartials: ->
    Ember.keys(env.availability).forEach (avail, index) ->
      Ember.TEMPLATES["availability/#{avail}"] = Ember.Handlebars.compile(
        "<div class='td'>" +
        "  <div class='switch tiny'>" +
        "    {{view Ember.RadioButton name='Availability' selection=availability value='#{avail}'}}" +
        "    <label for='#{avail}'></label>" +
        "  </div>" +
        "</div>" +
        "<div class='td space'>#{env.availability[avail]}</div>"
      )


  compileSkillPartials: ->
    Ember.keys(env.skills).forEach (skill, index) ->
      Ember.TEMPLATES["skills/#{skill}"] = Ember.Handlebars.compile(
        "<div class='td'>" +
        "  <div class='switch tiny'>" +
        "    {{view Ember.CheckMark selection=skill#{skill.toUpperCase()}}}" +
        "    <label for='#{skill}'></label>" +
        "  </div>" +
        "</div>" +
        "<div class='td space'>#{env.skills[skill]}</div>"
      )


  compileLanguagePartials: ->
    Ember.keys(env.languages).forEach (lang, index) ->
      Ember.TEMPLATES["languages/#{lang}"] = Ember.Handlebars.compile(
        "<div class='td'>" +
        "  <div class='switch tiny'>" +
        "    {{view Ember.CheckMark selection=language#{lang.toUpperCase()}}}" +
        "    <label for='#{lang}'></label>" +
        "  </div>" +
        "</div>" +
        "<div class='td space'>#{env.languages[lang]}</div>"
      )


  initFoundation: ->
    ($ document).foundation()


  originateCall: ->
    app.dialog('Enter a number to dial to:',
      'dialog', 'Dial now', 'Cancel', '', 'number'
    ).then (num) ->
      Voice.Call.originate(num)
    , (->)


  agentRegex: /^(SIP\/)?(\d\d\d\d?)$/


  ticketSpinnerOn: ->
    ($ '.tickets_table .fa-refresh').addClass('fa-spin')

  ticketSpinnerOff: ->
    ($ '.tickets_table .fa-refresh').removeClass('fa-spin')



  getZendeskUserFrom: (zendeskId) ->
    return "" unless zendeskId
    agent = Voice.get('allUsers').find (u) -> u.get('zendeskId') == zendeskId

    if agent
     "#{agent.get 'name'} / #{agent.get 'displayName'}"
    else
      zendeskId


  getAgentFrom: (callerId) ->
    return "" unless callerId

    matches = "#{callerId}".match(app.agentRegex)
    name    = if matches then matches[2] else ""
    agent   = Voice.get('allUsers').find (u) -> u.get('name') == name

    if agent
     "#{agent.get 'name'} / #{agent.get 'displayName'}"
    else
      callerId


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
    @agentOverviewToggle()
    @mySettingsToggle()
    @callQueueToggle()
    @setupLabelInputs()


  showAgentOverview: ->
    ($ '#call_queue').removeClass('expanded')


  toggleAgentOverview: ->
    app.hideTooltips()
    ($ '#call_queue').toggleClass('expanded')


  agentOverviewToggle: ->
    ($ '#agent_overview > h5').click -> app.toggleAgentOverview()


  toggleSettings: ->
      app.hideTooltips()
      ($ '#my_settings').toggleClass('expanded')
      ($ '#call_queue').toggleClass('lifted')


  mySettingsToggle: ->
    ($ '#my_settings > h5').click -> app.toggleSettings()


  toggleStatsView: ->
    if Voice.get('currentPath') == 'stats'
      Voice.aR.transitionTo('/')
    else
      Voice.aR.transitionTo('/stats')


  cycleAvailability: ->
    cu    = Voice.get('currentUser')
    avail = switch cu.get('availability')
              when 'ready' then 'busy'
              when 'busy'  then 'away'
              when 'away'  then 'ready'

    cu.set('availability', avail)


  toggleCallQueue: ->
    app.hideTooltips()
    ($ '#call_queue').addClass('expanded').addClass('lifted')
    ($ '#my_settings').removeClass('expanded')


  callQueueToggle: ->
    ($ '#call_queue > h5').click (evt) ->
      return if evt.target.className.match('talking')
      app.toggleCallQueue()


  setupLabelInputs: ->
    ($ document).on 'click', '#my_settings label', (el) ->
      ($ el.target).siblings('input').click()


  updateUserFrom: (data) ->
    @updateRecordFrom(data, 'user', Voice.User)


  updateCallFrom: (data) ->
    @updateRecordFrom(data, 'call', Voice.Call)


  createMessageFrom: (data) ->
    return if data.chat_message.from == Voice.get('currentUser.email')
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


  parseIncomingData: (data) ->
    if data.user
      app.updateUserFrom(data)
    else if data.call
      app.updateCallFrom(data)
    else if data.chat_message
      app.createMessageFrom(data)
    else if data.servertime
      app.resetServerTimer()


  takeIncomingCall: (call, name) ->
    par = if Voice.callIsOriginate
      message: "Do you want to call<br /><strong>#{name}</strong>?"
      textYes: 'Yes, dial'
      textNo:  'Cancel'
      call:     call
    else
      message:  "You have an incoming call from<br /><strong>#{name}</strong>"
      textYes:  'Take call'
      textNo:   'I\'m busy'
      call:     call

    Voice.callIsOriginate = false
    @showDialDialog(par)


  showDialDialog: (par) ->
    app.dialog(
      par.message, 'question', par.textYes, par.textNo
    ).then ( ->
      env.callDialogActive = false
      phone.app.answer(par.call.id, false)
    ), ( ->
      env.callDialogActive = false
      phone.app.hangup(par.call.id)
    )
}
