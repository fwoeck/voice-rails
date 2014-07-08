Voice.User = DS.Model.extend(Voice.LanguageSettings, Voice.SkillSettings, {

  email:         DS.attr 'string'
  roles:         DS.attr 'string'
  skills:        DS.attr 'string'
  fullname:      DS.attr 'string'
  languages:     DS.attr 'string'
  availability:  DS.attr 'string'


  didLoad: ->
    @splitLanguages()
    @splitSkills()

})
