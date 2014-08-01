Voice.EntryController = Ember.ObjectController.extend({

  callIsCurrent: (->
    Voice.get('currentCall.id') == @get('content.callId')
  ).property('content.callId', 'Voice.currentCall')
})
