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
      description: @get 'content.remarks'
      subject:     @getSubject()
    ).save().then ->
      Voice.get('currentCustomer').fetchCrmTickets(true)


  getSubject: ->
    call  = Voice.get('currentCall.origin')
    i18n.crmuser.default_subject.replace('CALL', call.get 'id')


  crmuserIsActive: (->
    !!Voice.get('currentUser.crmuserId') &&
      !!@get('customer.crmuserId') && !!@get('content.remarks')
  ).property(
    'customer.crmuserId', 'content.remarks',
    'Voice.currentUser.crmuserId'
  )
})