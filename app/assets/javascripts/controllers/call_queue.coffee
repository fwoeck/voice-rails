Voice.CallQueueController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.calls.content'

  callSorting: ['calledAt']

  inboundCalls: Ember.computed.sort 'activeCalls', 'callSorting'

  activeCalls: Ember.computed.filter('activeCalls',
    (call) -> !call.get('hungup') && call.get('initiator')
  ).property('content.@each.{hungup,initiator}')

})
