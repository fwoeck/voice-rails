Voice.MySettingsController = Ember.ObjectController.extend({

  needs:          ['users']
  contentBinding:  'Voice.currentUser'


  init: ->
    @_super()
    @splitLanguages()


  splitLanguages: ( ->
    Ember.keys(env.languages).forEach (lang) =>
      key = "language#{lang.toUpperCase()}"
      val = @isSet(lang)
      @set(key, val) if @get(key) != val
  ).observes('languages')


  isSet: (lang) ->
    !!@get('languages').match(lang)


  joinLanguages: ( ->
    languages = []
    Ember.keys(env.languages).forEach (lang) =>
      languages.push lang if @isSet(lang)

    newVal = languages.sort().join(',')
    @set('languages', newVal) if newVal != @get('languages')
  ).observes(
    'languageDE', 'languageEN', 'languageES',
    'languageFR', 'languageIT'
  )


  saveOnUpdate: (->
    Ember.run.later(@, @saveCurrentUser, 50)
  ).observes('content.{availability,skills,languages}')


  saveCurrentUser: ->
    cu = Voice.get('currentUser')
    cu.save() if cu.get('currentState.stateName') != 'root.loaded.saved'
})
