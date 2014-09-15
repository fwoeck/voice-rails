Voice.LanguageSettings = Ember.Mixin.create({

  splitLanguages: ( ->
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      val = @langIsSet(lang)
      @set(key, val) if @get(key) != val
  ).observes('languages')


  langIsSet: (lang) ->
    @get('languages').indexOf(lang) > -1


  joinLanguages: ->
    newLangs = []
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      newLangs.push(lang) if @get(key)

    newVal = newLangs.sort()
    @set('languages', newVal) if Ember.compare(newVal, @get 'languages')


  observeLanguages: ->
    self = @
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      @addObserver(key, -> Ember.run.scheduleOnce 'actions', self, self.joinLanguages)
})
