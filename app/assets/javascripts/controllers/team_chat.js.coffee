Voice.TeamChatController = Ember.ArrayController.extend({

  needs:        ['chatMessages']
  modelBinding: Ember.Binding.oneWay 'controllers.chatMessages'
})
