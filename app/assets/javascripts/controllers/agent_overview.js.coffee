Voice.AgentOverviewController = Ember.ArrayController.extend({

  pattern: ''
  needs: ['calls', 'users']
  contentBinding: 'controllers.users'


  matchingAgents: (->
    pattern = @get('pattern').toLowerCase()
    agents  = @get('content')

    return [] unless agents
    return agents unless pattern

    agents.filter (agent) ->
      agent.get('displayName').toLowerCase().match(pattern) ||
      agent.get('name').match(pattern)
  ).property('pattern', 'content.@each.fullname')


  currentStatusLine: (->
    available = @get('content.availableAgents')
    are       = if available == 1 then 'agent is' else 'agents are'

    "#{available} #{are} available."
  ).property('content.availableAgents')
})
