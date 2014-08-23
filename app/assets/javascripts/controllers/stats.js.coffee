Voice.StatsController = Ember.ArrayController.extend({

  dataBinding: 'Voice.allDatasets.firstObject'
  rrdSource:   ''


  skills: (->
    Ember.keys(env.skills)
  ).property()


  skillWidth: (->
    width = 100/@get('skills.length')
    "#{width}%"
  ).property('skills')


  availabilities: (->
    Ember.keys(env.availability)
  ).property()


  languages: (->
    Ember.keys(env.languages)
  ).property()


  titleActiveCalls: (->
    i18n.calls.active_calls
  ).property()


  titleIncomingCalls: (->
    i18n.calls.incoming_calls
  ).property()


  titleQueuedCalls: (->
    i18n.calls.queued_calls
  ).property()


  titleDispatchedCalls: (->
    i18n.calls.dispatched_calls
  ).property()


  titleMaxQueueDelay: (->
    i18n.calls.max_queue_delay
  ).property()


  titleAvgQueueDelay: (->
    i18n.calls.avg_queue_delay
  ).property()


  labelCallCount: (->
    i18n.calls.call_count
  ).property()


  labelSeconds: (->
    i18n.calls.seconds
  ).property()
})
