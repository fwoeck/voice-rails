Voice.SearchResult = DS.Model.extend({

  entrySorting:   ['createdAt:desc']
  historyEntries: DS.hasMany 'historyEntry'
  orderedEntries: Ember.computed.sort 'historyEntries', 'entrySorting'

  email:          DS.attr 'string'
  fullName:       DS.attr 'string'
  crmuserId:      DS.attr 'string'
  callerIds:      DS.attr 'array'
})
