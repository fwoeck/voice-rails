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
    @controllerFor('users').set 'model', @store.all('user')
    @controllerFor('calls').set 'model', @store.all('call')
    @controllerFor('chatMessages').set 'model', @store.all('chatMessage')

    Voice.set 'allCalls',     @store.all('call')
    Voice.set 'allUsers',     @store.all('user')
    Voice.set 'allTickets',   @store.all('zendeskTicket')
    Voice.set 'allCustomers', @store.all('customer')
    Voice.set 'currentUser',  @store.getById('user', env.userId)


  shortcuts:
    'esc':    'closeDialog'
    'ctrl+n': 'dialNumber'
    'ctrl+s': 'toggleStats'
    'ctrl+a': 'toggleAgents'
    'ctrl+d': 'showDashboard'
    'ctrl+q': 'showCallQueue'
    'ctrl+h': 'showHelpDialog'
    'ctrl+o': 'toggleAgentOverview'
    'ctrl+j': 'toggleForeignCalls'
    'ctrl+f': 'activateSearch'
    'ctrl+t': 'activateChat'
    'ctrl+r': 'setReady'
    'ctrl+b': 'setBusy'


  silence: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false


  actions:
    showHelpDialog: (e) ->
      text = Ember.keys(i18n.help).reduce(
        ((arr, key) -> arr.concat(i18n.help[key])), []
      ).join('<br />')
      app.showDefaultMessage(
        '<span class="header">' + i18n.dialog.shortcut_header +
        '</span><span class="list">' + text + '</span>'
      )
      @silence(e)


    closeDialog: (e) ->
      Voice.dialogController.cancel()
      @silence(e)

    dialNumber: (e) ->
      app.originateCall()
      @silence(e)

    showCallQueue: (e) ->
      app.toggleCallQueue()
      @silence(e)

    setReady: (e) ->
      app.setAvailability('ready')
      @silence(e)

    setBusy: (e) ->
      app.setAvailability('busy')
      @silence(e)

    showDashboard: (e) ->
      Voice.aR.transitionTo('/')
      @silence(e)

    toggleStats: (e) ->
      app.toggleStatsView()
      @silence(e)

    toggleAgentOverview: (e) ->
      app.toggleAgentOverview()
      @silence(e)

    toggleAgents: (e) ->
      app.toggleAgentView()
      @silence(e)

    toggleForeignCalls: (e) ->
      Voice.toggleProperty('hideForeignCalls')
      @silence(e)

    activateSearch: (e) ->
      Ember.run.next -> ($ 'input[name=agent_search]').focus()
      @silence(e)

    activateChat: (e) ->
      Ember.run.next -> ($ 'input[name=chat_message]').focus()
      @silence(e)
})
