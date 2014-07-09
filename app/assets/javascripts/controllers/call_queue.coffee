Voice.CallQueueController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.calls.content'


  activeCalls: Ember.computed.filter('content',
    (call) -> !call.get('hungup')
  ).property('content.@each.hungup')


  callPairs: Ember.computed.filter('activeCalls',
    (call) ->
      @get('activeCalls').every( (ac) ->
        (Ember.compare(call, ac) != 0  ) ||
        (
          call.get('id')  > ac.get('id') ||
          call.get('id') == ac.get('id')
        )
      )
  ).property('activeCalls.@each.{channel1,id}')

})
