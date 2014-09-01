Voice.AgentOverviewController = Ember.ArrayController.extend({

  pattern: ''
  needs: ['calls', 'users']
  contentBinding: 'controllers.users.allAgents'


  matchingAgents: (->
    pattern = @get('pattern').toLowerCase()
    agents  = @get('content')

    return agents unless pattern
    agents.filter (agent) -> agent.matchesSearch(pattern)
  ).property('pattern', 'content.[]')


  currentStatusLine: (->
    count = @get('controllers.users.availableAgents')
    are   = if count == 1
              i18n.agents.agent_is
            else
              i18n.agents.agents_are

    "#{count} #{are} #{i18n.agents.available}."
  ).property('controllers.users.availableAgents')
})
