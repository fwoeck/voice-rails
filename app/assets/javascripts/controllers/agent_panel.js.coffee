Voice.AgentPanelController = Ember.ObjectController.extend({

  cuIsAdminBinding: Ember.Binding.oneWay 'controllers.users.cuIsAdmin'
  formIsActive:     false
  needs:            ['users']


  actions:
    callAgent: (agent) ->
      cu = Voice.get('currentUser')
      if cu != agent && cu.get('isCallable') && agent.get('isCallable')
        agent.call()
      false


  cuCanEditAgent: (->
    cu = Voice.get('currentUser')
    @get('cuIsAdmin') && cu != @get('model')
  ).property('cuIsAdmin', 'model')
})
