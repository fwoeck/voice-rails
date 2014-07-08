Voice.User = DS.Model.extend({

  email:         DS.attr 'string'
  roles:         DS.attr 'string'
  skills:        DS.attr 'string'
  fullname:      DS.attr 'string'
  languages:     DS.attr 'string'
  availability:  DS.attr 'string'


  didLoad: ->
    @splitLanguages()


  splitLanguages: ( ->
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      val = @isSet(lang)
      @set(key, val) if @get(key) != val
  ).observes('languages')


  isSet: (lang) ->
    !!@get('languages').match(lang)


  joinLanguages: ->
    newLangs = []
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      newLangs.push(lang) if @get(key)

    newVal = newLangs.sort().join(',')
    @set('languages', newVal) if newVal != @get('languages')


  observeLanguages: ( ->
    Ember.run.scheduleOnce 'actions', @, @joinLanguages
  ).observes(
    'languageDE', 'languageEN', 'languageES',
    'languageFR', 'languageIT'
  )

})
