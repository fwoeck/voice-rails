Voice.AgentsController = Ember.ArrayController.extend({

  needs:            ['users']
  cuIsAdminBinding: 'controllers.users.cuIsAdmin'
})
