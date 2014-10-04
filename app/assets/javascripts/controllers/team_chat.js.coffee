Voice.TeamChatController = Ember.ArrayController.extend({

  needs:       ['chatMessages']
  modelBinding: 'controllers.chatMessages'
})
