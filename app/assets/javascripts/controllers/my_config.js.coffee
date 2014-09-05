Voice.MyConfigController = Ember.ObjectController.extend(Voice.AgentForm, {

  contentBinding: 'Voice.currentUser'
  agentIsNew:     false
  cuIsAdmin:      false
})
