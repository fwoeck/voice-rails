Voice.AgentsController = Ember.ArrayController.extend({

  needs:            ['users']
  cuIsAdminBinding: Ember.Binding.oneWay 'controllers.users.cuIsAdmin'
})
