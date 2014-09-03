Voice.User = DS.Model.extend(Voice.LanguageSettings, Voice.SkillSettings, {

  name:          DS.attr 'string'
  email:         DS.attr 'string'
  roles:         DS.attr 'string'
  skills:        DS.attr 'string'
  secret:        DS.attr 'string'
  password:      DS.attr 'string'
  fullName:      DS.attr 'string'
  activity:      DS.attr 'string'
  languages:     DS.attr 'string'
  zendeskId:     DS.attr 'string'
  visibility:    DS.attr 'string'
  confirmation:  DS.attr 'string'
  availability:  DS.attr 'string'


  gravatarUrl: (->
    email = @get 'email'
    return "" unless env.patterns.email.test(email)
    gravatar(email, size: 48)
  ).property('email')


  didLoad: ->
    @splitLanguages()
    @splitSkills()

    @observeLanguages()
    @observeSkills()


  call: ->
    Voice.callIsOriginate = true
    Voice.Call.originate @get('name')


  displayName: (->
    @get('fullName') || @get('email')
  ).property('fullName')


  matchesSearch: (pattern) ->
    try
      @get('fullName').toLowerCase().match(pattern) ||
      @get('email').toLowerCase().match(pattern) ||
      @get('name').match(pattern)
    catch
      false


  displayLangs: (->
    @get('languages')?.split(',').map((l) -> l.toUpperCase()).join(', ')
  ).property('languages')


  displaySkills: (->
    @get('skills')?.split(',').map((l) -> l.capitalize())
                   .join(', ').replace(/_booking/g, 'Book')
  ).property('skills')


  displayRoles: (->
    @get('roles')?.split(',').map((l) -> l.capitalize()).join(', ')
  ).property('roles')


  isCallable: (->
    @get('activity') == 'silent' && @get('visibility') == 'online'
  ).property('activity', 'visibility')
})
