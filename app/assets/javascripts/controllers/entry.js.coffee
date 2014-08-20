Voice.EntryController = Ember.ObjectController.extend({

  needs: ['customer']
  customerBinding: 'controllers.customer.content'


  actions:
    toZendeskTicket: ->
      @createZendeskTicket()
      false


  createZendeskTicket: ->
    @store.createRecord('zendeskTicket',
      requesterId: @get 'customer.zendeskId'
      subject:     @get 'remarks'
      description: @getDescription()
    ).save().then ->
      Voice.get('currentCustomer').fetchZendeskTickets()


  getDescription: ->
    call = Voice.currentCall.get('origin')
    time = moment(call.get 'calledAt').format()
    i18n.zendesk.default_descr.replace('TIME', time).replace('CALL', call.get 'id')


  zendeskIsActive: (->
    !!Voice.get('currentUser.zendeskId') &&
      !!@get('customer.zendeskId') && !!@get('remarks')
  ).property(
    'customer.zendeskId', 'remarks',
    'Voice.currentUser.zendeskId'
  )


  callIsCurrent: (->
    Voice.get('currentCall.id') == @get('content.callId')
  ).property('content.callId', 'Voice.currentCall')


  mailboxPlayer: (->
    mailbox = @get 'content.mailbox'
    "player-#{mailbox}" if mailbox
  ).property('content.mailbox')


  mailboxContainer: (->
    mailbox = @get 'content.mailbox'
    "container-#{mailbox}" if mailbox
  ).property('content.mailbox')
})
