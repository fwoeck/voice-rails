Voice.AgentOverviewController = Ember.ArrayController.extend({

  pattern: ''
  needs: ['calls', 'users']
  contentBinding: 'controllers.users'


  matchingAgents: (->
    pattern =  @get('pattern').toLowerCase()
    agents  = (@get('content') || []).filter (agent) -> !agent.get('isNew')

    return agents unless pattern
    agents.filter (agent) -> agent.matchesSearch(pattern)
  ).property('pattern', 'content.[]')


  currentStatusLine: (->
    count = @get('content.availableAgents')
    are   = if count == 1
              i18n.agents.agent_is
            else
              i18n.agents.agents_are

    "#{count} #{are} #{i18n.agents.available}."
  ).property('content.availableAgents')
})
