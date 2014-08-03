Voice.Customer = DS.Model.extend({

  entrySorting:   ['createdAt:desc']
  historyEntries: DS.hasMany 'historyEntry'
  orderedEntries: Ember.computed.sort 'historyEntries', 'entrySorting'

  ticketSorting:  ['createdAt:desc']
  orderedTickets: Ember.computed.sort 'zendeskTickets', 'ticketSorting'

  email:          DS.attr 'string'
  fullname:       DS.attr 'string'
  zendeskId:      DS.attr 'string'
  callerIds:      DS.attr 'array'


  fetchZendeskTickets: ->
    @notifyPropertyChange('zendeskId')


  zendeskTickets: (->
    return [] unless (zid = @get 'zendeskId')
    app.ticketSpinnerOn()
    tickets = @store.findQuery('zendeskTicket', requester_id: zid)
    tickets.then -> app.ticketSpinnerOff()
    tickets
  ).property('zendeskId')
})
