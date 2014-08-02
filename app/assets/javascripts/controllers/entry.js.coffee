Voice.EntryController = Ember.ObjectController.extend({

  callIsCurrent: (->
    Voice.get('currentCall.id') == @get('content.callId')
  ).property('content.callId', 'Voice.currentCall')


  mailboxPlayer: (->
    mailbox = @get 'content.mailbox'
    "player-#{mailbox}" if mailbox
  ).property('content.mailbox')


  mailboxContainer: (->
    mailbox = @get 'content.mailbox'
    "container-#{mailbox}" if mailbox
  ).property('content.mailbox')
})
