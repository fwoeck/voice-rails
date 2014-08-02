Voice.CustomerController = Ember.ObjectController.extend({

  contentBinding: 'parentController.customers.firstObject'


  actions:
    syncZendesk: ->
      cust = @get('content')
      if cust
        cust.set('zendeskId', 'requested..')
        cust.save()
      false

    storeRecord: ->
      @get('content')?.save()
      false


  dirty: (->
    @get('content.currentState.stateName') != 'root.loaded.saved'
  ).property('content.currentState.stateName')


  zendeskUserUrl: (->
    uid = @get('content.zendeskId')
    "https://dokmatic.zendesk.com/agent/#/users/#{uid}/requested_tickets"
  ).property('content.zendeskId')
})
