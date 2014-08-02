Voice.CompCall = Ember.Mixin.create({

  compare: (x, y) ->
    return 0 if x.get('channel1') == y.get('channel1')
    return 1
})


Voice.Call = DS.Model.extend(Ember.Comparable, Voice.CompCall, {

  allCallsBinding: 'Voice.allCalls'
  allUsersBinding: 'Voice.allUsers'


  skill:         DS.attr 'string'
  hungup:        DS.attr 'boolean'
  mailbox:       DS.attr 'string'
  calledAt:      DS.attr 'date'
  callerId:      DS.attr 'string'
  channel1:      DS.attr 'string'
  channel2:      DS.attr 'string'
  connLine:      DS.attr 'string'
  hungupAt:      DS.attr 'date'
  language:      DS.attr 'string'
  queuedAt:      DS.attr 'date'
  dispatchedAt:  DS.attr 'date'


  init: ->
    @_super()
    @updateMatchesFilter()


  skillName: ( ->
    skill = @get('skill')
    skill.replace(/_booking/, ' booking').capitalize() if skill
  ).property('skill')


  hangup: ->
    callId = @get('id')
    $.post("/calls/#{callId}", {'_method': 'DELETE'})


  transfer: (to) ->
    callId = @get('id')
    $.post("/calls/#{callId}/transfer", {'to': to})


  callerName: ( ->
    app.getAgentFrom(@get 'callerId')
  ).property('callerId')


  agent: ( ->
    users = @get('allUsers')
    chan  = @get('channel1')
    return false unless users && chan

    users.find (user) -> chan.match(user.get 'name')
  ).property('allUsers.@each.name', 'channel1')


  myCallLeg: ( ->
    name  = Voice.get('currentUser.name')
    regex = RegExp "^SIP\/#{name}-"

    @get('agentsCallLeg') && (
      regex.test(@get 'channel1') || regex.test(@get 'channel2')
    )
  ).property('channel1', 'channel2', 'agentsCallLeg')


  # FIXME We infer the agent side call leg from the language
  #       not being set. Can we improve this?
  #
  agentsCallLeg: ( ->
    !!@get('channel2') && !@get('language')
  ).property('channel2', 'language')


  origin: (->
    calls = @get('allCalls')
    chan  = @get('channel2')
    return false unless calls && chan

    calls.find (call) -> call.get('channel2') == chan && !call.get('agentsCallLeg')
  ).property('allCalls.@each.{channel2,agentsCallLeg}')


  bridge: (->
    calls = @get('allCalls')
    chan  = @get('channel2')
    return false unless calls && chan

    calls.find (call) -> call.get('channel2') == chan && call.get('agentsCallLeg')
  ).property('allCalls.@each.{channel2,agentsCallLeg}')


  updateMatchesFilter: (->
    result = if Voice.get('hideForeignCalls')
      @isInbound() && @matchesCU()
    else
      @isInbound()

    if @get('matchesFilter') != result
       @set 'matchesFilter', result
  ).observes(
    'hungup', 'connLine', 'language' ,'skill'
    'Voice.currentUser.{languages,skills}',
    'Voice.hideForeignCalls'
  )


  matchesCU: ->
    cu = Voice.get('currentUser')
    !!cu.get('languages').match(@get 'language') &&
      !!cu.get('skills').match(@get 'skill')


  isInbound: ->
    !@get('hungup') && !@get('connLine')
})
