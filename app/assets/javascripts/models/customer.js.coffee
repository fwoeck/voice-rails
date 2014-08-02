Voice.Customer = DS.Model.extend({

  entrySorting:   ['createdAt:desc']
  historyEntries: DS.hasMany 'historyEntry'
  orderedEntries: Ember.computed.sort 'historyEntries', 'entrySorting'

  email:          DS.attr 'string'
  fullname:       DS.attr 'string'
  zendeskId:      DS.attr 'string'
  callerIds:      DS.attr 'array'
})
