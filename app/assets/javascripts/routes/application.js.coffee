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
    'ctrl+d': 'dialNumber'
    'ctrl+s': 'toggleStats'
    'ctrl+q': 'showCallQueue'
    'ctrl+o': 'toggleAgentOverview'
    'ctrl+h': 'toggleForeignCalls'
    'ctrl+a': 'cycleAvailability'
    'ctrl+f': 'activateSearch'
    'ctrl+t': 'activateChat'


  actions:
    dialNumber: ->
      app.originateCall()
      false

    showCallQueue: ->
      app.toggleCallQueue()
      false

    toggleStats: ->
      app.toggleStatsView()
      false

    toggleAgentOverview: ->
      app.toggleAgentOverview()
      false

    cycleAvailability: ->
      app.cycleAvailability()
      false

    toggleForeignCalls: ->
      Voice.toggleProperty('hideForeignCalls')
      false

    activateSearch: ->
      Ember.run.next -> ($ 'input[name=agent_search]').focus()
      false

    activateChat: ->
      Ember.run.next -> ($ 'input[name=chat_message]').focus()
      false
})
