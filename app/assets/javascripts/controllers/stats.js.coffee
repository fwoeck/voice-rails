Voice.StatsController = Ember.ArrayController.extend({

  needs:             ['datasets']
  dataBinding:        'controllers.datasets.content.firstObject'
  statsPausedBinding: 'Voice.statsPaused'
  rrdSource:          ''


  actions:

    startCycling: ->
      @set 'statsPaused', false
      false

    pauseCycling: ->
      @set 'statsPaused', true
      false


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
