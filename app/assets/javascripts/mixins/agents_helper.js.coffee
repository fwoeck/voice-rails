Voice.AgentsHelper = Ember.Mixin.create({

  pattern:      ''
  needs:        ['calls', 'users']
  modelBinding: Ember.Binding.oneWay 'controllers.users.allAgents'
  patternTimer: null


  observePattern: (->
    Ember.run.cancel(@patternTimer) if @patternTimer
    @patternTimer = Ember.run.later @, @updateMatches, 500
  ).observes('pattern')


  observeAgents: (->
    @notifyPropertyChange('matchingAgents')
  ).observes('model.[]')


  updateMatches: ->
    @patternTimer = null
    app.resetScrollPanes()
    app.removeJScrollPane()
    @notifyPropertyChange('matchingAgents')


  sortedAgents: ->
    @get('content').sort (a, b) ->
      Ember.compare a.get('fullName'), b.get('fullName')


  matchingAgents: (->
    pattern = @get('pattern').toLowerCase()
    agents  = @sortedAgents()

    return agents unless pattern
    agents.filter (agent) -> agent.matchesSearch(pattern)
  ).property()
})
