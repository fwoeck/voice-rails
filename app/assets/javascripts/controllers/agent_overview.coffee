Voice.AgentOverviewController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.users.content'

})
