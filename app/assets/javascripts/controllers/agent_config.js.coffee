Voice.AgentConfigController = Ember.ObjectController.extend(Voice.AgentForm, {

  agentIsNew: false
  cuIsAdmin:  true


  agentFormId: (->
    "agent_form_#{@get 'model.id'}"
  ).property('model.id')
})
