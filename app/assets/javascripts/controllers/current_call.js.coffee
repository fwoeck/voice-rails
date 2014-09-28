Voice.CurrentCallController = Ember.ObjectController.extend({

  callerIdBinding: 'Voice.currentCall.origin.callerId'
  customerBinding: 'Voice.currentCustomer'


  init: ->
    @_super()
    @fetchCustomers()


  actions:
    closeCurrentCall: ->
      app.closeCurrentCall()
      false


  fetchCustomers: (->
    @store.unloadAll('customer')
    @store.unloadAll('historyEntry')
    return [] unless cid = @get('callerId')

    @store.findQuery('customer', caller_id: cid)
  ).observes('callerId')
})
