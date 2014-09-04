Voice.AgentPanelController = Ember.ObjectController.extend({

  needs: ['users']
  cuIsAdminBinding:   'controllers.users.cuIsAdmin'
  currentFormBinding: 'controllers.users.currentForm'


  actions:

    editAgent: ->
      app.expandAgentForm ($ '#agent_table_wrapper'), true
      @set('currentForm', @get 'model')
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


  formIsActive: (->
    @get('currentForm') == @get('model')
  ).property('currentForm', 'model')
})
