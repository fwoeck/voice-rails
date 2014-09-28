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
  forceReload:    false


  crmuserUrl: (->
    uid = @get 'crmuserId'
    env.crmUserUrl.replace('USERID', uid)
  ).property('crmuserId')


  fetchCrmTickets: (reload) ->
    @set('forceReload', reload)
    @notifyPropertyChange('crmuserId')


  crmTickets: (->
    return [] unless (zid = @get 'crmuserId')
    app.ticketSpinnerOn()

    reload = @get('forceReload')
    @set('forceReload', false)

    @requestTickets(zid, reload)
  ).property('crmuserId')


  requestTickets: (zid, reload) ->
    @store.unloadAll('crmTicket')
    zt = @store.findQuery('crmTicket', requester_id: zid, reload: reload)
    zt.then -> app.ticketSpinnerOff()
    zt
})
