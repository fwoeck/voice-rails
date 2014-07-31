Voice.CallQueueController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  callSorting: ['calledAt']
  contentBinding: 'controllers.calls'
  hideForeignCallsBinding: 'Voice.hideForeignCalls'


  actions:
    hangupCall: ->
      cc = Voice.get('currentCall')
      return unless cc

      app.dialog(
        'Do you want to hangup your current call?', 'question'
      ).then ( ->
        cc.hangup()
      ), (->)
      return false


  filteredCalls: Ember.computed.filterBy 'content', 'matchesFilter', true
  sortedCalls:   Ember.computed.sort 'filteredCalls', 'callSorting'


  talking: ( ->
    !!Voice.get('currentCall')
  ).property('Voice.currentCall')


  waitingCalls: Ember.computed.filter('filteredCalls',
    (call) -> !call.get('bridge')
  ).property('filteredCalls.@each.bridge')


  currentStatusLine: (->
    waiting   = @get('waitingCalls.length')
    customers = if waiting == 1 then 'customer is' else 'customers are'

    "#{waiting} #{customers} queued."
  ).property('waitingCalls.length')
})
