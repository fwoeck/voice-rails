Voice.NewAgentController = Ember.ObjectController.extend(Voice.AgentForm, {

  modelBinding: Ember.Binding.oneWay 'controllers.agents.newAgent'
  agentFormId:  'new_agent_form'
  agentIsNew:   true
  cuIsAdmin:    true


  saveAgentData: (el) ->
    spin = el.find('.fa-refresh')
    @enableSpinner(spin)

    @get('model').save().then (=>
      @showSuccesMessage()
      @clearAgent()
    ), (->)


  clearAgent: ->
    agent = @get('model')
    agent.remove() if agent.get('isNew')
    @set('model', @store.createRecord Voice.User)


  showSuccesMessage: ->
    name = @get('model.displayName')
    app.showDefaultMessage(
      i18n.dialog.agent_created.replace('NAME', name)
    )


  gravatarUrl: (->
    'https://secure.gravatar.com/avatar/000?s=48'
  ).property()
})
