Voice.CompCall = Ember.Mixin.create({

  compare: (x, y) ->
    return 0 if x.get('channel1') == y.get('channel1')
    return 1

})


Voice.Call = DS.Model.extend(Ember.Comparable, Voice.CompCall, {

  allCallsBinding: 'Voice.allCalls'

  calledAt:     DS.attr 'date'
  callerId:     DS.attr 'string'
  channel1:     DS.attr 'string'
  channel2:     DS.attr 'string'
  dispatchedAt: DS.attr 'date'
  hungupAt:     DS.attr 'date'
  hungup:       DS.attr 'boolean'
  initiator:    DS.attr 'boolean'
  language:     DS.attr 'string'
  queuedAt:     DS.attr 'date'
  skill:        DS.attr 'string'


  bridge: (->
    calls = @get('allCalls')
    return false unless calls

    calls.find (call) =>
      !call.get('initiator') &&
      call.get('channel2') == @get('channel1')
  ).property('allCalls.@each.{initiator,channel2}', 'channel1')

})
