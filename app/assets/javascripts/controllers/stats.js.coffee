Voice.StatsController = Ember.ArrayController.extend({

  dataBinding: 'Voice.allDatasets.firstObject'
  rrdSource:   '/queue-stats.png'


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
})
