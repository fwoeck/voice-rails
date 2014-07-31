Voice.HistoryEntry = DS.Model.extend({

  customer:  DS.belongsTo('customer')

  skill:     DS.attr('string')
  callId:    DS.attr('string')
  remarks:   DS.attr('string')
  agentId:   DS.attr('number')
  language:  DS.attr('string')
  duration:  DS.attr('number')
  callerId:  DS.attr('string')
  createdAt: DS.attr('date')
})


Voice.Customer = DS.Model.extend({

  historyEntries: DS.hasMany 'historyEntry'

  email:          DS.attr 'string'
  fullname:       DS.attr 'string'
  zendeskId:      DS.attr 'number'
  callerIds:      DS.attr 'array'
})
