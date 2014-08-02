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

    Voice.set 'allCalls',    @store.all('call')
    Voice.set 'allUsers',    @store.all('user')
    Voice.set 'currentUser', @store.getById('user', env.userId)


  shortcuts:
    'ctrl+c': 'showCallQueue'
    'ctrl+s': 'toggleSettings'
    'ctrl+o': 'toggleAgentOverview'
    'ctrl+h': 'toggleForeignCalls'
    'ctrl+a': 'cycleAvailability'
    'ctrl+f': 'activateSearch'
    'ctrl+t': 'activateChat'


  actions:
    showCallQueue: ->
      app.toggleCallQueue()
      false

    toggleSettings: ->
      app.toggleSettings()
      false

    toggleAgentOverview: ->
      app.toggleAgentOverview()
      false

    cycleAvailability: ->
      cu    = Voice.get('currentUser')
      avail = switch cu.get('availability')
                when 'ready' then 'busy'
                when 'busy'  then 'away'
                when 'away'  then 'ready'

      cu.set('availability', avail)
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
