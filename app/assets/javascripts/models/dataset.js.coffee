Voice.Dataset = DS.Model.extend({

  activeCallCount:     DS.attr 'number'
  queuedCallCount:     DS.attr 'number'
  preQueuedCallCount:  DS.attr 'number'
  dispatchedCallCount: DS.attr 'number'
  queuedCallsDelayMax: DS.attr 'number'
  queuedCallsDelayAvg: DS.attr 'number'

})
