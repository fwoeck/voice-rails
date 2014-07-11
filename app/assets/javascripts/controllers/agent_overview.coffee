Voice.AgentOverviewController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.users'


  currentStatusLine: (->
    available  = @get('content.availableAgents')
    registered = @get('content.registeredAgents')
    agents     = if registered == 1 then 'agent is' else 'agents are'
    are        = if available == 1 then 'is' else 'are'

    "#{registered} #{agents} online — #{available} #{are} available."
  ).property('content.{availableAgents,registeredAgents}')

})
