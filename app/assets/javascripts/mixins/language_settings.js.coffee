Voice.LanguageSettings = Ember.Mixin.create({

  splitLanguages: ( ->
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      val = @langIsSet(lang)
      @set(key, val) if @get(key) != val
  ).observes('languages')


  langIsSet: (lang) ->
    langs = @get('languages') || ""
    !!langs.match(lang)


  joinLanguages: ->
    newLangs = []
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      newLangs.push(lang) if @get(key)

    newVal = newLangs.sort().join(',')
    @set('languages', newVal) if newVal != @get('languages')


  observeLanguages: ->
    self = @
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      @addObserver(key, -> Ember.run.scheduleOnce 'actions', self, self.joinLanguages)
})
