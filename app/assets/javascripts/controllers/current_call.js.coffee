Voice.CurrentCallController = Ember.ObjectController.extend({

  callerIdBinding: Ember.Binding.oneWay 'Voice.currentCall.callerId'
  customerBinding: Ember.Binding.oneWay 'Voice.currentCustomer'


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
