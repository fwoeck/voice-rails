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
  reload:         false


  fetchZendeskTickets: (reload) ->
    @set('reload', reload)
    @notifyPropertyChange('zendeskId')


  zendeskTickets: (->
    return [] unless (zid = @get 'zendeskId')
    app.ticketSpinnerOn()

    reload = @get('reload')
    @set('reload', false)

    zt = @store.findQuery('zendeskTicket', requester_id: zid, reload: reload)
    zt.then -> app.ticketSpinnerOff()
    zt
  ).property('zendeskId')
})
