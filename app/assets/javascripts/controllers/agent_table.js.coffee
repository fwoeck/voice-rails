Voice.AgentTableController = Ember.ArrayController.extend({

  pattern: ''
  needs: ['calls', 'users']
  contentBinding: 'controllers.users.allAgents'


  matchingAgents: (->
    pattern = @get('pattern').toLowerCase()
    agents  = @get('content')

    return agents unless pattern
    agents.filter (agent) -> agent.matchesSearch(pattern)
  ).property('pattern', 'content.[]')
})
