Voice.CurrentCallController = Ember.ObjectController.extend({

  callerIdBinding: 'Voice.currentCall.origin.callerId'


  customers: (->
    @store.unloadAll('customer')
    @store.unloadAll('historyEntry')
    return [] unless cid = @get('callerId')

    @store.findQuery('customer', caller_id: cid)
  ).property('callerId')


  setCurrentCustomer: (->
    customer = @get('customers.content.firstObject')
    Voice.set 'currentCustomer', customer
  ).observes('customers.content.[]')
})
