Voice.ApplicationRoute = Ember.Route.extend({

  model: ->
    Voice.store = @store
    Voice.aR    = @router

    Ember.RSVP.all([
      @store.find('user'),
      @store.find('call'),
      @store.find('chatMessage')
    ])


  activate: ->
    @controllerFor('users').set        'model', @store.all('user')
    @controllerFor('calls').set        'model', @store.all('call')
    @controllerFor('customers').set    'model', @store.all('customer')
    @controllerFor('chatMessages').set 'model', @store.all('chatMessage')

    Voice.set 'allUsers',     @store.all('user')
    Voice.set 'allCustomers', @store.all('customer')
    Voice.set 'currentUser',  @store.getById('user', env.userId)


  shortcuts:
    'return': 'confirmDialog'
    'esc':    'closeDialog'
    'ctrl+o': 'dialNumber'
    'ctrl+h': 'hangupCall'
    'ctrl+x': 'closeCall'
    'ctrl+s': 'toggleStats'
    'ctrl+a': 'toggleAgents'
    'ctrl+d': 'showDashboard'
    'ctrl+i': 'showHelpDialog'
    'ctrl+f': 'activateSearch'
    'ctrl+m': 'activateChat'
    'ctrl+r': 'setReady'
    'ctrl+b': 'setBusy'


  silence: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false


  actions:
    error: (error, transition) ->
      app.showDefaultError(i18n.errors.routing_error)
      console.log error
      false

    showHelpDialog: (e) ->
      app.showShortcutList()
      @silence(e)

    confirmDialog: (e) ->
      Voice.dialogController.accept()
      @silence(e)

    closeDialog: (e) ->
      Voice.dialogController.cancel()
      @silence(e)

    dialNumber: (e) ->
      app.originateCall()
      @silence(e)

    closeCall: (e) ->
      app.closeCurrentCall()
      @silence(e)

    hangupCall: (e) ->
      app.hangupCurrentCall()
      @silence(e)

    setReady: (e) ->
      app.setAvailability('ready')
      @silence(e)

    setBusy: (e) ->
      app.setAvailability('busy')
      @silence(e)

    showDashboard: (e) ->
      Voice.aR.transitionTo('/') unless app.skipTransition(e)
      @silence(e)

    toggleStats: (e) ->
      app.toggleStatsView() unless app.skipTransition(e)
      @silence(e)

    toggleAgents: (e) ->
      app.toggleAgentView() unless app.skipTransition(e)
      @silence(e)

    activateSearch: (e) ->
      Ember.run.next -> ($ 'input[name=agent_search]').focus()
      @silence(e)

    activateChat: (e) ->
      Ember.run.next -> ($ 'input[name=chat_message]').focus()
      @silence(e)
})
