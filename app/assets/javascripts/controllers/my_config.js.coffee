Voice.MyConfigController = Ember.ObjectController.extend(Voice.AgentForm, {

  modelBinding: Ember.Binding.oneWay 'Voice.currentUser'
  agentIsNew:   false
  cuIsAdmin:    false
})
