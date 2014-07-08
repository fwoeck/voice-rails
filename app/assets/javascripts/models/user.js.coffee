Voice.User = DS.Model.extend({

  email:         DS.attr 'string'
  roles:         DS.attr 'string'
  skills:        DS.attr 'string'
  fullname:      DS.attr 'string'
  languages:     DS.attr 'string'
  availability:  DS.attr 'string'


  didLoad: ->
    @splitSkills()
    @splitLanguages()


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



  splitSkills: ( ->
    Ember.keys(env.skills).forEach (skill) =>
      key = "skill#{skill.toUpperCase()}"
      val = @skillIsSet(skill)
      @set(key, val) if @get(key) != val
  ).observes('skills')


  skillIsSet: (skill) ->
    !!@get('skills').match(skill)


  joinSkills: ->
    newSkills = []
    Ember.keys(env.skills).forEach (skill) =>
      key = "skill#{skill.toUpperCase()}"
      newSkills.push(skill) if @get(key)

    newVal = newSkills.sort().join(',')
    @set('skills', newVal) if newVal != @get('skills')


  observeSkills: ( ->
    Ember.run.scheduleOnce 'actions', @, @joinSkills
  ).observes(
    'skillOFFERS', 'skillBILLING', 'skillBOOKING',
    'skillOTHER'
  )

})
