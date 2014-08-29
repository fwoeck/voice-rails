Voice.NewAgentController = Ember.ObjectController.extend(Voice.AgentForm, {

  clearAgent: ->
    @set 'model', @store.createRecord(Voice.User)


  gravatarUrl: (->
    'https://secure.gravatar.com/avatar/000?s=48'
  ).property()
})
