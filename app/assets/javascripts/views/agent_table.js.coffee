Voice.AgentTableView = Ember.View.extend({

  actions:
    expandPane: ->
      app.expandAgentForm @$(), true
})
