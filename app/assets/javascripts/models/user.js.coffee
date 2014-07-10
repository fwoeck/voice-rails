Voice.User = DS.Model.extend(Voice.LanguageSettings, Voice.SkillSettings, {

  name:          DS.attr 'string'
  email:         DS.attr 'string'
  roles:         DS.attr 'string'
  skills:        DS.attr 'string'
  fullname:      DS.attr 'string'
  languages:     DS.attr 'string'
  agentState:    DS.attr 'string'
  availability:  DS.attr 'string'


  didLoad: ->
    @splitLanguages()
    @splitSkills()


  displayName: (->
    @get('fullname') || @get('email')
  ).property('fullname')


  displayLangs: (->
    @get('languages').split(',').map((l) -> l.toUpperCase()).join(', ')
  ).property('languages')


  displaySkills: (->
    @get('skills').split(',').map((l) -> l.capitalize()).join(', ')
  ).property('skills')

})
