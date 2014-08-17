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
    'ctrl+d': 'dialNumber'
    'ctrl+s': 'toggleStats'
    'ctrl+q': 'showCallQueue'
    'ctrl+o': 'toggleAgentOverview'
    'ctrl+h': 'toggleForeignCalls'
    'ctrl+a': 'cycleAvailability'
    'ctrl+f': 'activateSearch'
    'ctrl+t': 'activateChat'


  silence: (e) ->
    e.preventDefault()
    e.stopPropagation()
    false


  actions:
    closeDialog: (e) ->
      Voice.dialogController.cancel()
      @silence(e)

    dialNumber: (e) ->
      app.originateCall()
      @silence(e)

    showCallQueue: (e) ->
      app.toggleCallQueue()
      @silence(e)

    toggleStats: (e) ->
      app.toggleStatsView()
      @silence(e)

    toggleAgentOverview: (e) ->
      app.toggleAgentOverview()
      @silence(e)

    cycleAvailability: (e) ->
      app.cycleAvailability()
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
