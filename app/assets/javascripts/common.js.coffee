window.app = {

  setCurrentAgentForm: (el) ->
    return unless (av = Voice.get 'agentsView')

    if el?[0] != av.get('currentForm')?[0]
      av.set('currentForm', el)
    else
      av.set('currentForm', null)


  # TODO This needs some generalization/i18n:
  #
  parseAjaxError: (msg) ->
    validationRegex = /Validation failed: /
    if validationRegex.test(msg)
      msg = msg.replace(validationRegex, '')
               .split(', ').uniq().join(', ')
               .replace('Name', 'SIP Extension')
    msg


  expandAgentForm: (oldF, curF) ->
    @toggleAgentTable(curF)

    if oldF
      oldF.find('.agent_form_wrapper').removeClass('expanded')

    if curF
      Ember.run.later @, (->
        curF.find('.agent_form_wrapper').addClass('expanded')
      ), 100


  toggleAgentTable: (curF) ->
    tableId = '#agent_table_wrapper'
    table   = ($ tableId)

    if !curF || curF.find(tableId).length || table.find(curF).length
      table.addClass('expanded')
    else
      table.removeClass('expanded')


  aggregateSkillSelection: ->
    env.skillSelection = Ember.keys(env.skills).sort().reduce(
      ((arr, key) -> arr.concat({id: key, name: env.skills[key]})), []
    )


  aggregateLanguageSelection: ->
    env.languageSelection = Ember.keys(env.languages).sort().reduce(
      ((arr, key) -> arr.concat({id: key, name: key.toUpperCase()})), []
    )


  aggregateRoleSelection: ->
    env.roleSelection = Ember.keys(env.roles).sort().reduce(
      ((arr, key) -> arr.concat({id: key, name: env.roles[key]})), []
    )


  showShortcutList: ->
    text = Ember.keys(i18n.help).sort().reduce(
      ((arr, key) -> arr.concat(i18n.help[key])), []
    ).join('<br />')
    app.showDefaultMessage(
      '<span class="header">' + i18n.dialog.shortcut_header +
      '</span><span class="list">' + text + '</span>'
    )


  closeCurrentCall: ->
    cc = Voice.get('currentCall')
    co = cc?.get('origin')

    if cc && cc.get('hungup')
      Voice.set('currentCall', null)
      cc.remove()
      co.remove() if co && co.get('hungup')

      if app.loadLocalKey('useAutoReady')
        app.setAvailability('ready')
    else
      app.showDefaultError(i18n.dialog.no_hungup_call)

  
  hangupCurrentCall: ->
    cc = Voice.get('currentCall')
    app.hangupCall(cc) if cc && !cc.get('hungup')


  hangupCall: (call) ->
    app.dialog(i18n.dialog.hangup_this_call,
      'question', i18n.dialog.hangup, i18n.dialog.cancel
    ).then ( ->
      call.hangup()
    ), (->)


  renderStatsEntry: (val, level1, level2) ->
    tag = if val
            lef = 'norm'
            lev = 'warn' if val > level1
            lev = 'err'  if val > level2
            "<span class='#{lev}'>#{val}</span>"
          else
            "<span class='empty'>&mdash;</span>"

    new Ember.Handlebars.SafeString(tag)


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


  setupAbide: ->
    env.patterns = Foundation.libs.abide.settings.patterns
    env.patterns.password = /^.*(?=.{8,20})(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*$/


  initFoundation: ->
    Ember.run.scheduleOnce 'afterRender', app, app.callFoundation


  callFoundation: ->
    ($ document).foundation()


  originateCall: (number='') ->
    if Voice.get('currentCall')
      app.showDefaultError(i18n.errors.line_is_busy)
    else
      app.dialog(i18n.dialog.enter_number,
        'dialog', i18n.dialog.dial_now, i18n.dialog.cancel, number, 'number'
      ).then (num) ->
        Voice.Call.originate(num)
      , (->)


  agentRegex:  /^(SIP\/)?(\d\d\d\d?)$/
  phoneNumber: /(^| )(\+?[0-9]+[0-9 .\/-]+[0-9])/g


  ticketSpinnerOn: ->
    ($ '.tickets_table .fa-refresh').addClass('fa-spin')

  ticketSpinnerOff: ->
    ($ '.tickets_table .fa-refresh').removeClass('fa-spin')



  renderAgentName: (agent, alt) ->
    if agent
     "#{agent.get 'name'} / #{agent.get 'displayName'}"
    else
      alt


  getAgent: (userId) ->
    return "" unless userId

    agent = Voice.store.getById('user', userId)
    @renderAgentName(agent, "Agent ##{userId}")


  getCrmUserFrom: (crmuserId) ->
    return "" unless crmuserId

    agent = Voice.get('allUsers').find (u) -> u.get('crmuserId') == crmuserId
    @renderAgentName(agent, "User ##{crmuserId}")


  getAgentFrom: (callerId) ->
    return "" unless callerId

    matches = "#{callerId}".match(app.agentRegex)
    name    = if matches then matches[2] else ""
    agent   = Voice.get('allUsers').find (u) -> u.get('name') == name
    @renderAgentName(agent, callerId)


  resetServerTimer: ->
    window.clearTimeout(env.serverTimeout) if env.serverTimeout
    env.serverTimeout = window.setTimeout (->
      app.dialog(i18n.dialog.no_messages, 'error').then (->
        app.logout()
      )
    ), 12000


  logout: ->
    phone.app.logoff() unless Modernizr.touch
    $.post('/auth/logout', {'_method': 'DELETE'}). then (->
      window.location.reload()
    )


  noLogin: ->
    !env.userId


  setupDashboard: ->
    @agentOverviewToggle()
    @mySettingsToggle()
    @callQueueToggle()
    @setupLabelInputs()


  cleanupDashboard: ->
    @unbindLabelInputs()


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


  toggleAgentView: ->
    if Voice.get('currentPath') == 'agents'
      Voice.aR.transitionTo('/')
    else
      Voice.aR.transitionTo('/agents')


  toggleStatsView: ->
    if Voice.get('currentPath') == 'stats'
      Voice.aR.transitionTo('/')
    else
      Voice.aR.transitionTo('/stats')


  setAvailability: (avail) ->
    cu = Voice.get('currentUser')
    cu?.set('availability', avail)


  toggleCallQueue: ->
    app.hideTooltips()
    ($ '#call_queue').addClass('expanded').addClass('lifted')
    ($ '#my_settings').removeClass('expanded')


  callQueueToggle: ->
    ($ '#call_queue > h5').click (evt) ->
      return if evt.target.className.match('talking')
      app.toggleCallQueue()


  unbindLabelInputs: ->
    ($ '#my_settings label').off 'click'


  setupLabelInputs: ->
    ($ '#my_settings label').on 'click', (el) ->
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
      unless obj.get('isDeleted')
        @writeToObject(obj, klass, data, name)
    else
      Voice.store.pushPayload(name, data)


  writeToObject: (obj, klass, data, name) ->
    Voice.aS.normalizeAttributes(klass, data[name])
    @updateKeysFromData(obj, name, data)
    obj.markAsSaved()


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


  dialog: (
    message, type='question', textYes=i18n.dialog.ok,
    textNo=i18n.dialog.cancel, text, format
  ) ->
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
      message: i18n.dialog.outgoing_call.replace('NAME', name)
      textYes: i18n.dialog.dial_now
      textNo:  i18n.dialog.cancel
      call:    call
    else
      message: i18n.dialog.incoming_call.replace('NAME', name)
      textYes: i18n.dialog.take_call
      textNo:  i18n.dialog.i_am_busy
      call:    call

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
