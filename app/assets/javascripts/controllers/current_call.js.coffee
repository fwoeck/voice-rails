Voice.CurrentCallController = Ember.ObjectController.extend({

  needs:           ['customers']
  callerIdBinding:  'Voice.currentCall.origin.callerId'
  customersBinding: 'controllers.customers.content'


  init: ->
    @_super()
    @fetchCustomers()


  fetchCustomers: (->
    @store.unloadAll('customer')
    @store.unloadAll('historyEntry')
    return [] unless cid = @get('callerId')

    @store.findQuery('customer', caller_id: cid)
  ).observes('callerId')


  setCurrentCustomer: (->
    customer = @get('customers.firstObject')
    Voice.set 'currentCustomer', customer
  ).observes('customers.[]')
})
