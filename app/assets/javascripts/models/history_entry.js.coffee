Voice.HistoryEntry = DS.Model.extend(Voice.Resetable, {

  customer:  DS.belongsTo('customer')

  callId:    DS.attr('string')
  mailbox:   DS.attr('string')
  remarks:   DS.attr('string')
  callerId:  DS.attr('string')
  extension: DS.attr('string')
  createdAt: DS.attr('date')
})
