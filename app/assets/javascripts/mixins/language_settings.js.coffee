Voice.LanguageSettings = Ember.Mixin.create({

  splitLanguages: ( ->
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      val = @langIsSet(lang)
      @set(key, val) if @get(key) != val
  ).observes('languages')


  langIsSet: (lang) ->
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
