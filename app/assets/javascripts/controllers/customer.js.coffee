Voice.CustomerController = Ember.ObjectController.extend({

  contentBinding: 'parentController.customers.firstObject'


  actions:
    syncCrm: ->
      if (cust = @get 'content')
        cust.set('crmuserId', '...') # FIXME This is ugly.
        cust.save()
      false

    storeRecord: ->
      cust = @get('content')
      cust && cust.get('isDirty') && cust.save()
      false

    fetchCrmTickets: ->
      Voice.get('currentCustomer').fetchCrmTickets(true)
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
