Voice.HistoryEntry = DS.Model.extend(Voice.Resetable, {

  customer:  DS.belongsTo('customer')

  tags:      DS.attr('array')
  callId:    DS.attr('string')
  userId:    DS.attr('number')
  mailbox:   DS.attr('string')
  remarks:   DS.attr('string')
  callerId:  DS.attr('string')
  createdAt: DS.attr('date')


  status: (->
    dt = Voice.HistoryEntry.defaultTags
    @get('tags').find (tag) ->
      return tag if dt.indexOf(tag) > -1
  ).property('tags.[]')
})


Voice.HistoryEntry.reopenClass({
  
  defaultTags: Ember.keys(env.defaultTags)
})
