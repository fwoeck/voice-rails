Voice.CallQueueController = Ember.ArrayController.extend({

  needs:              ['calls', 'users']
  callSorting:        ['calledAt']
  modelBinding:       Ember.Binding.oneWay 'controllers.calls.content'
  currentCallBinding: Ember.Binding.oneWay 'Voice.currentCall'

  showDispatchedCallsBinding: 'Voice.showDispatchedCalls'

  filteredCalls: Ember.computed.filterBy 'content',       'matchesFilter', true
  sortedCalls:   Ember.computed.sort     'filteredCalls', 'callSorting'


  waitingCalls: Ember.computed.filter('filteredCalls',
    (call) -> !call.get('bridge')
  ).property('filteredCalls.@each.bridge')


  currentStatusLine: (->
    count = @get('waitingCalls.length')
    are   = if count == 1
              i18n.customers.customer_is
            else
              i18n.customers.customers_are

    "#{count} #{are} #{i18n.customers.queued}."
  ).property('waitingCalls.length')
})
