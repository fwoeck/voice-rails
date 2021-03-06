Voice.CompCall = Ember.Mixin.create({

  compare: (x, y) ->
    return 0 if x.get('id') == y.get('id')
    return 1
})


Voice.Call = DS.Model.extend(Ember.Comparable, Voice.CompCall, Voice.Resetable, {

  showDispatchedCallsBinding: Ember.Binding.oneWay 'Voice.showDispatchedCalls'
  allUsersBinding:            Ember.Binding.oneWay 'Voice.allUsers'

  origin:       null
  bridge:       null

  skill:        DS.attr 'string'
  callTag:      DS.attr 'string'
  mailbox:      DS.attr 'string'
  calledAt:     DS.attr 'date'
  callerId:     DS.attr 'string'
  hungupAt:     DS.attr 'date'
  language:     DS.attr 'string'
  originId:     DS.attr 'string'
  queuedAt:     DS.attr 'date'
  extension:    DS.attr 'string'
  dispatchedAt: DS.attr 'date'


  init: ->
    @_super()
    @updateMatchesFilter()


  skillName: ( ->
    skill = @get('skill')
    skill.replace(/_/, ' ').capitalize() if skill
  ).property('skill')


  hangup: ->
    callId = @get('id')
    $.post("/#{env.apiVersion}/calls/#{callId}", {'_method': 'DELETE'})


  readyForWipe: ->
    if (hungupAt = @get 'hungupAt')
      !@get('isDeleted') && (new Date - hungupAt > 3000) && @isForeignCall()


  isForeignCall: ->
    return true unless @get('callTag')
    cc = Voice.get('currentCall')
    !cc || @ != cc && @ != cc.get('origin')


  transfer: (to) ->
    callId = @get('id')
    $.post("/#{env.apiVersion}/calls/#{callId}/transfer", {'to': to})


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
    @get('extension') == env.sipAgent
  ).property('extension')


  agentCallLeg: ( ->
    @get('extension') != '0'
  ).property('extension')


  updateMatchesFilter: (->
    Ember.run.scheduleOnce 'afterRender', @, @writeFilterValue
  ).observes('visibleInQueue')


  writeFilterValue: ->
    result = @get('visibleInQueue')
    if @get('matchesFilter') != result
      @set 'matchesFilter', result


  visibleInQueue: (->
    !@get('hungupAt') && !@get('agentCallLeg') && (
      @get('showDispatchedCalls') || !@get('bridge')
    )
  ).property(
    'hungupAt', 'agentCallLeg', 'showDispatchedCalls', 'bridge'
  )
})


Voice.Call.reopenClass({

  originate: (to) ->
    Voice.outboundCall = to
    $.post "/#{env.apiVersion}/calls", to: to
})
