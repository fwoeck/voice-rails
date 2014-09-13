Voice.HistoryEntry = DS.Model.extend(Voice.Resetable, {

  customer:  DS.belongsTo('customer')

  callId:    DS.attr('string')
  userId:    DS.attr('number')
  mailbox:   DS.attr('string')
  remarks:   DS.attr('string')
  callerId:  DS.attr('string')
  createdAt: DS.attr('date')
})
