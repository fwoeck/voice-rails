Voice.CurrentEntryController = Ember.ObjectController.extend({

  needs: ['customer']
  customerBinding: 'controllers.customer.content'


  actions:
    toCrmTicket: ->
      @createCrmTicket()
      false


  createCrmTicket: ->
    @store.createRecord('crmTicket',
      requesterId: @get 'customer.crmuserId'
      subject:     @get 'content.remarks'
      description: @getDescription()
    ).save().then ->
      Voice.get('currentCustomer').fetchCrmTickets(true)


  getDescription: ->
    call  = Voice.get('currentCall.origin')
    agent = Voice.get('currentUser.displayName')
    time  = moment(call.get 'calledAt').format('LLL')

    i18n.crmuser.default_descr
        .replace('TIME',  time)
        .replace('AGENT', agent)
        .replace('CALL',  call.get 'id')


  crmuserIsActive: (->
    !!Voice.get('currentUser.crmuserId') &&
      !!@get('customer.crmuserId') && !!@get('content.remarks')
  ).property(
    'customer.crmuserId', 'content.remarks',
    'Voice.currentUser.crmuserId'
  )
})
