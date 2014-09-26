Voice.AgentsHelper = Ember.Mixin.create({

  pattern: ''
  needs: ['calls', 'users']
  modelBinding: 'controllers.users.allAgents'


  matchingAgents: (->
    pattern = @get('pattern').toLowerCase()
    agents  = @get('content').sort (a, b) ->
      Ember.compare a.get('fullName'), b.get('fullName')

    return agents unless pattern
    agents.filter (agent) -> agent.matchesSearch(pattern)
  ).property('pattern', 'content.@each.{fullName,email,name}')
})
