Voice.CompCall = Ember.Mixin.create({

  compare: (x, y) ->
    return 0 if x.get('id') == y.get('id')
    return 1
})


Voice.Call = DS.Model.extend(Ember.Comparable, Voice.CompCall, Voice.Resetable, {

  allCallsBinding: 'Voice.allCalls'
  allUsersBinding: 'Voice.allUsers'


  skill:         DS.attr 'string'
  hungup:        DS.attr 'boolean'
  callTag:       DS.attr 'string'
  mailbox:       DS.attr 'string'
  calledAt:      DS.attr 'date'
  callerId:      DS.attr 'string'
  hungupAt:      DS.attr 'date'
  language:      DS.attr 'string'
  queuedAt:      DS.attr 'date'
  extension:     DS.attr 'string'
  dispatchedAt:  DS.attr 'date'


  init: ->
    @_super()
    @updateMatchesFilter()


  skillName: ( ->
    skill = @get('skill')
    skill.replace(/_/, ' ').capitalize() if skill
  ).property('skill')


  hangup: ->
    callId = @get('id')
    $.post("/calls/#{callId}", {'_method': 'DELETE'})


  removeAfterHangup: (->
    if @get('hungup') && @isForeignCall()
      Ember.run.later @, @remove, 3000
  ).observes('hungup')


  isForeignCall: ->
    cc = Voice.get('currentCall')
    !cc || @ != cc && @ != cc.get('origin')


  transfer: (to) ->
    callId = @get('id')
    $.post("/calls/#{callId}/transfer", {'to': to})


  callerName: ( ->
    app.getAgentFrom(@get 'callerId')
  ).property('callerId')


  agent: ( ->
    users = @get('allUsers')
    ext   = @get('extension')
    return false unless users && ext

    users.find (user) -> ext == user.get('name')
  ).property('allUsers.@each.name', 'extension')


  myCallLeg: ( ->
    name  = Voice.get('currentUser.name')
    @get('extension') == name
  ).property('extension')


  agentsCallLeg: ( ->
    @get('extension') != '0'
  ).property('extension')


  origin: (->
    calls = @get('allCalls')
    tag   = @get('callTag')
    return false unless calls && tag

    calls.find (call) -> call.get('callTag') == tag && !call.get('agentsCallLeg')
  ).property('allCalls.@each.{callTag,agentsCallLeg}')


  bridge: (->
    calls = @get('allCalls')
    tag   = @get('callTag')
    return false unless calls && tag

    calls.find (call) -> call.get('callTag') == tag && call.get('agentsCallLeg')
  ).property('allCalls.@each.{callTag,agentsCallLeg}')


  updateMatchesFilter: (->
    result = if Voice.get('hideForeignCalls')
      @isInbound() && @matchesCU()
    else
      @isInbound()

    if @get('matchesFilter') != result
       @set 'matchesFilter', result
  ).observes(
    'hungup', 'agentsCallLeg', 'language' ,'skill'
    'Voice.currentUser.{languages,skills}.[]',
    'Voice.hideForeignCalls'
  )


  matchesCU: ->
    cu = Voice.get('currentUser')
    cu.get('languages').indexOf(@get 'language') > -1 &&
      cu.get('skills').indexOf(@get 'skill') > -1


  isInbound: ->
    !@get('hungup') && !@get('agentsCallLeg')
})


Voice.Call.reopenClass({

  originate: (to) ->
    $.post '/calls', to: to
})
