Voice.CustomerController = Ember.ObjectController.extend({

  actions:
    syncCrm: ->
      if (cust = @get 'content')
        # FIXME We use the ... as indication to request a new
        #       userId, that's ugly:
        #
        cust.set('crmuserId', '...')
        cust.save()
      false

    storeRecord: ->
      cust = @get('content')
      cust && cust.get('isDirty') && cust.save()
      false

    fetchCrmTickets: ->
      @get('content').fetchCrmTickets(true)
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


  crmActive: (->
    env.crmActive
  ).property()
})


Voice.CurrentCustomerController = Voice.CustomerController.extend({

  modelBinding: Ember.Binding.oneWay 'Voice.currentCustomer'


  crmActive: (->
    env.crmActive
  ).property()
})
