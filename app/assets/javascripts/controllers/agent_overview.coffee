Voice.AgentOverviewController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.users'


  currentStatusLine: (->
    available  = @get('content.availableAgents')
    registered = @get('content.registeredAgents')
    agents     = if registered == 1 then 'agent is' else 'agents are'

    "#{registered} #{agents} currently online — with #{available} available."
  ).property('content.{availableAgents,registeredAgents}')

})
