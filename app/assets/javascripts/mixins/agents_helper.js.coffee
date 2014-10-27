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
    @notifyPropertyChange('matchingAgents')


  matchingAgents: (->
    pattern = @get('pattern').toLowerCase()
    agents  = @get('content').sort (a, b) ->
      Ember.compare a.get('fullName'), b.get('fullName')

    return agents unless pattern
    agents.filter (agent) -> agent.matchesSearch(pattern)
  ).property()
})
