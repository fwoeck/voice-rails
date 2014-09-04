Voice.AgentTableView = Ember.View.extend({

  actions:
    expandPane: ->
      app.setCurrentAgentForm @$()
      false
})
