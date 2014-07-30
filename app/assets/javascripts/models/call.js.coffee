Voice.CompCall = Ember.Mixin.create({

  compare: (x, y) ->
    return 0 if x.get('channel1') == y.get('channel1')
    return 1
})


Voice.Call = DS.Model.extend(Ember.Comparable, Voice.CompCall, {

  allCallsBinding: 'Voice.allCalls'
  allUsersBinding: 'Voice.allUsers'


  skill:        DS.attr 'string'
  hungup:       DS.attr 'boolean'
  calledAt:     DS.attr 'date'
  callerId:     DS.attr 'string'
  channel1:     DS.attr 'string'
  channel2:     DS.attr 'string'
  connLine:     DS.attr 'string'
  hungupAt:     DS.attr 'date'
  language:     DS.attr 'string'
  queuedAt:     DS.attr 'date'
  dispatchedAt: DS.attr 'date'


  skillName: ( ->
    skill = @get('skill')
    skill.replace(/_booking/, ' booking').capitalize() if skill
  ).property('skill')


  myCall: ( ->
    chan1 = @get('channel1')
    chan2 = @get('channel2')
    name  = Voice.get('currentUser.name')
    regex = "^SIP.#{name}-"

    chan1?.match(regex) || chan2?.match(regex)
  ).property('channel1', 'channel2')


  hangup: ->
    callId = @get('id')
    $.post("/calls/#{callId}", {'_method': 'DELETE'})


  transfer: (to) ->
    callId = @get('id')
    $.post("/calls/#{callId}/transfer", {'to': to})


  agent: ( ->
    users = @get('allUsers')
    chan  = @get('channel1')
    return false unless users && chan

    users.find (user) -> chan.match(user.get 'name')
  ).property('allUsers.@each.name', 'channel1')


  origin: (->
    calls = @get('allCalls')
    chan  = @get('channel2')
    return false unless calls && chan

    calls.find (call) -> call.get('channel2') == chan && !call.get('connLine')
  ).property('allCalls.@each.{channel2,connLine}')


  bridge: (->
    calls = @get('allCalls')
    chan  = @get('channel2')
    return false unless calls && chan

    calls.find (call) -> call.get('channel2') == chan && !!call.get('connLine')
  ).property('allCalls.@each.{channel2,connLine}')
})
