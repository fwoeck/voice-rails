Voice.Customer = DS.Model.extend(Voice.Resetable, {

  entrySorting:   ['createdAt:desc']
  historyEntries: DS.hasMany 'historyEntry'
  orderedEntries: Ember.computed.sort 'historyEntries', 'entrySorting'

  ticketSorting:  ['createdAt:desc']
  orderedTickets: Ember.computed.sort 'zendeskTickets', 'ticketSorting'

  email:          DS.attr 'string'
  fullName:       DS.attr 'string'
  zendeskId:      DS.attr 'string'
  callerIds:      DS.attr 'array'


  fetchZendeskTickets: ->
    @notifyPropertyChange('zendeskId')


  zendeskTickets: (->
    return [] unless (zid = @get 'zendeskId')
    app.ticketSpinnerOn()

    zt = @store.findQuery('zendeskTicket', requester_id: zid)
    zt.then -> app.ticketSpinnerOff()
    zt
  ).property('zendeskId')
})
