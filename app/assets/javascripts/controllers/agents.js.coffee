Voice.AgentsController = Ember.ArrayController.extend({

  cuIsAdmin: (->
    /admin/.test(Voice.get 'currentUser.roles')
  ).property('Voice.currentUser.roles')


  newAgent: (->
    Voice.store.createRecord(Voice.User)
  ).property()
})
