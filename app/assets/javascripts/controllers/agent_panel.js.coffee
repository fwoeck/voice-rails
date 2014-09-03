Voice.AgentPanelController = Ember.ObjectController.extend({

  needs: ['users']
  cuIsAdminBinding: 'controllers.users.cuIsAdmin'


  actions:

    editAgent: ->
      app.expandAgentForm ($ '#agent_table_wrapper'), true
      false

    callAgent: (agent) ->
      cu = Voice.get('currentUser')

      if cu != agent && cu.get('isCallable') && agent.get('isCallable')
        agent.call()
      false


  cuCanEditAgent: (->
    cu = Voice.get('currentUser')
    @get('cuIsAdmin') || cu == @get('model')
  ).property('cuIsAdmin')
})
