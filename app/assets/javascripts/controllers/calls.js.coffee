Voice.CallsController = Ember.ArrayController.extend({
})


Voice.InboundCallController = Ember.ObjectController.extend({
})


Voice.CurrentCallController = Ember.ObjectController.extend({

  callerIdBinding: 'Voice.currentCall.origin.callerId'

  customers: (->
    @store.findQuery 'customer', caller_id: @get('callerId')
  ).property('callerId')
})
