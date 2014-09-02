Voice.AgentOverviewController = Ember.ArrayController.extend(Voice.AgentsHelper, {

  currentStatusLine: (->
    count = @get('controllers.users.availableAgents')
    are   = if count == 1
              i18n.agents.agent_is
            else
              i18n.agents.agents_are

    "#{count} #{are} #{i18n.agents.available}."
  ).property('controllers.users.availableAgents')
})
