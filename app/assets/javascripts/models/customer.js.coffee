Voice.Customer = DS.Model.extend(Voice.Resetable, {

  entrySorting:   ['createdAt:desc']
  historyEntries: DS.hasMany 'historyEntry'
  orderedEntries: Ember.computed.sort 'historyEntries', 'entrySorting'

  ticketSorting:  ['createdAt:desc']
  orderedTickets: Ember.computed.sort 'crmTickets', 'ticketSorting'

  email:          DS.attr 'string'
  fullName:       DS.attr 'string'
  crmuserId:      DS.attr 'string'
  callerIds:      DS.attr 'array'
  reload:         false


  fetchCrmTickets: (reload) ->
    @set('reload', reload)
    @notifyPropertyChange('crmuserId')


  crmTickets: (->
    return [] unless (zid = @get 'crmuserId')
    app.ticketSpinnerOn()

    reload = @get('reload')
    @set('reload', false)

    zt = @store.findQuery('crmTicket', requester_id: zid, reload: reload)
    zt.then -> app.ticketSpinnerOff()
    zt
  ).property('crmuserId')
})
