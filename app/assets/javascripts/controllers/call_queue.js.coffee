Voice.CallQueueController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  callSorting: ['calledAt']
  contentBinding: 'controllers.calls'
  hideForeignCallsBinding: 'Voice.hideForeignCalls'


  actions:
    hangupCall: ->
      app.hangupCurrentCall()
      return false


  filteredCalls: Ember.computed.filterBy 'content', 'matchesFilter', true
  sortedCalls:   Ember.computed.sort 'filteredCalls', 'callSorting'


  init: ->
    @_super()
    @restoreHideForeignCalls()


  restoreHideForeignCalls: ->
    Ember.run.next =>
      @set 'hideForeignCalls', app.loadLocalKey('hideForeignCalls')


  persistHideForeignCalls: (->
    app.storeLocalKey('hideForeignCalls', @get 'hideForeignCalls')
  ).observes('hideForeignCalls')


  talking: ( ->
    cc = Voice.get('currentCall')
    cc && !cc.get('hungup')
  ).property('Voice.currentCall.hungup')


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
