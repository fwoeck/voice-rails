Voice.MyConfigController = Ember.ObjectController.extend(Voice.AgentForm, {

  modelBinding: 'Voice.currentUser'
  agentIsNew:    false
  cuIsAdmin:     false
})
