Voice.HistoryEntry = DS.Model.extend(Voice.Resetable, {

  tags:       DS.attr('array')
  callId:     DS.attr('string')
  userId:     DS.attr('number')
  mailbox:    DS.attr('string')
  remarks:    DS.attr('string')
  callerId:   DS.attr('string')
  createdAt:  DS.attr('date')
  customerId: DS.attr('string')


  status: (->
    dt = Voice.HistoryEntry.defaultTags
    @get('tags').find (tag) ->
      return tag if dt.indexOf(tag) > -1
  ).property('tags.[]')


  addToTags: (tag) ->
    tags = @get('tags')

    unless tags.indexOf(tag) > -1
      @removeDefaultTags(tag)
      tags.addObject(tag)
      @save()


  removeDefaultTags: (tag) ->
    dt   = Voice.HistoryEntry.defaultTags
    tags = @get('tags')

    if dt.indexOf(tag) > -1
      dt.forEach (dt) -> tags.removeObject(dt)


  removeFromTags: (tag) ->
    tags = @get('tags')
    tags.removeObject(tag)
    @save()
})


Voice.HistoryEntry.reopenClass({
  
  defaultTags: Ember.keys(env.defaultTags)
})
