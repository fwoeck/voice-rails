Voice.NewAgentController = Ember.ObjectController.extend(Voice.AgentForm, {

  agentIsNew: true


  clearAgent: ->
    @get('model').deleteRecord()
    @set('model', @store.createRecord Voice.User)


  gravatarUrl: (->
    'https://secure.gravatar.com/avatar/000?s=48'
  ).property()


  cuIsAdmin: (->
    /admin/.test(Voice.get 'currentUser.roles')
  ).property('Voice.currentUser.roles')
})
