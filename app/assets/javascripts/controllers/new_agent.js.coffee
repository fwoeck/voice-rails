Voice.NewAgentController = Ember.ObjectController.extend(Voice.AgentForm, {

  needs:          ['agents']
  agentIsNew:     true
  contentBinding: 'controllers.agents.newAgent'


  saveAgentData: (el) ->
    spin = el.find('.fa-refresh')
    @enableSpinner(spin)

    @get('model').save().then (=>
      @showSuccesMessage()
      @clearAgent()
    ), (->)


  clearAgent: ->
    agent = @get('model')
    agent.deleteRecord() if agent.get('isNew')
    @set('model', @store.createRecord Voice.User)


  showSuccesMessage: ->
    name = @get('model.displayName')
    role = @get('model.roles')?.split(',')[0] || i18n.domain.user

    app.showDefaultMessage(
      i18n.dialog.agent_created
                 .replace('NAME', name)
                 .replace('ROLE', role)
    )


  gravatarUrl: (->
    'https://secure.gravatar.com/avatar/000?s=48'
  ).property()


  cuIsAdmin: (->
    /admin/.test(Voice.get 'currentUser.roles')
  ).property('Voice.currentUser.roles')
})
