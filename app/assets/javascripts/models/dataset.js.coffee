Voice.Dataset = DS.Model.extend({

  activeCallCount:     DS.attr 'number'
  queuedCallCount:     DS.attr 'number'
  preQueuedCallCount:  DS.attr 'number'
  dispatchedCallCount: DS.attr 'number'
  queuedCallsDelayMax: DS.attr 'number'
  queuedCallsDelayAvg: DS.attr 'number'

  queuedCalls:         DS.attr 'object'
  dispatchedCalls:     DS.attr 'object'
  averageDelay:        DS.attr 'object'
  maxDelay:            DS.attr 'object'
})
