Voice.CustomerController = Ember.ObjectController.extend({

  contentBinding: 'parentController.customers.firstObject'


  actions:
    syncZendesk: ->
      if (cust = @get 'content')
        cust.set('zendeskId', '...') # FIXME This is ugly.
        cust.save()
      false

    storeRecord: ->
      @get('content')?.save()
      false

    fetchZendeskTickets: ->
      Voice.get('currentCustomer').fetchZendeskTickets()
      false


  dirty: (->
    @get('content.currentState.stateName') != 'root.loaded.saved'
  ).property('content.currentState.stateName')
})
