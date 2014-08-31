Voice.NewAgentController = Ember.ObjectController.extend(Voice.AgentForm, {

  agentIsNew: true


  saveAgentData: (el) ->
    spin = el.find('.fa-refresh')
    @enableSpinner(spin)

    @get('model').save().then (=>
      @showSuccesMessage()
      @clearAgent()
    ), (->)


  clearAgent: ->
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
