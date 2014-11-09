Voice.MyConfigController = Ember.ObjectController.extend(Voice.AgentForm, {

  modelBinding: Ember.Binding.oneWay 'Voice.currentUser'
  agentFormId:  'current_user_form'
  agentIsNew:   false
  cuIsAdmin:    false
})
