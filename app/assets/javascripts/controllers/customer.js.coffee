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
    cust = @get('content')
    cust && cust.get('isDirty')
  ).property('content.isDirty')


  fullNamePlaceholder: (->
    i18n.placeholder.the_full_name
  ).property()


  emailAddressPlaceholder: (->
    i18n.placeholder.an_email_address
  ).property()


  userIdPlaceholder: (->
    i18n.placeholder.the_user_id
  ).property()
})
