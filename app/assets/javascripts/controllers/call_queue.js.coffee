Voice.CallQueueController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  callSorting: ['calledAt']
  contentBinding: 'controllers.calls'
  hideForeignCallsBinding: 'Voice.hideForeignCalls'


  filteredCalls: Ember.computed.filterBy 'content', 'matchesFilter', true
  sortedCalls:   Ember.computed.sort 'filteredCalls', 'callSorting'


  waitingCalls: Ember.computed.filter('filteredCalls',
    (call) -> !call.get('bridge')
  ).property('filteredCalls.@each.bridge')


  currentStatusLine: (->
    waiting   = @get('waitingCalls.length')
    customers = if waiting == 1 then 'customer is' else 'customers are'

    "#{waiting} #{customers} queued."
  ).property('waitingCalls.length')
})
