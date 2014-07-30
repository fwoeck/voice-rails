Voice.CallQueueController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.calls'

  hideForeignCalls: true
  callSorting: ['calledAt']

  inboundCalls: Ember.computed.sort 'activeCalls', 'callSorting'


  activeCalls: Ember.computed.filter('content',
    (call) ->
      if @get 'hideForeignCalls'
        @callMatchesAgent(call)
      else
        @callIsInbound(call)
  ).property(
    'content.@each.{hungup,connLine,language,skill}',
    'Voice.currentUser.{languages,skills}',
    'hideForeignCalls'
  )


  callMatchesAgent: (call) ->
    cu = Voice.get('currentUser')
    @callIsInbound(call) &&
      cu.get('languages').match(call.get 'language') &&
      cu.get('skills').match(call.get 'skill')


  callIsInbound: (call) ->
    !call.get('hungup') && !call.get('connLine') &&
      !call.get('callerId').match(/^SIP.\d+$/)


  waitingCalls: Ember.computed.filter('activeCalls',
    (call) -> !call.get('bridge')
  ).property('activeCalls.@each.bridge')


  currentStatusLine: (->
    waiting   = @get('waitingCalls.length')
    customers = if waiting == 1 then 'customer is' else 'customers are'

    "#{waiting} #{customers} queued."
  ).property('waitingCalls.length')
})
