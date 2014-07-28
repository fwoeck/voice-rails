Voice.TeamChatController = Ember.ArrayController.extend({

  needs: ['chatMessages']
  contentBinding: 'controllers.chatMessages'
})
