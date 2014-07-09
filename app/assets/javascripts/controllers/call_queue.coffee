Voice.CallQueueController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.calls.content'


  activeCalls: Ember.computed.filter('content',
    (call) -> !call.get('hungup')
  ).property('content.@each.hungup')

})
