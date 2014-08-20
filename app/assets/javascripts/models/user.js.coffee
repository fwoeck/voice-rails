Voice.User = DS.Model.extend(Voice.LanguageSettings, Voice.SkillSettings, {

  name:          DS.attr 'string'
  email:         DS.attr 'string'
  roles:         DS.attr 'string'
  skills:        DS.attr 'string'
  fullname:      DS.attr 'string'
  activity:      DS.attr 'string'
  languages:     DS.attr 'string'
  zendeskId:     DS.attr 'string'
  visibility:    DS.attr 'string'
  availability:  DS.attr 'string'


  gravatarUrl: (->
    email = @get 'email'
    return unless email
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
    @get('fullname') || @get('email')
  ).property('fullname')


  matchesSearch: (pattern) ->
    try
      @get('fullname').toLowerCase().match(pattern) ||
      @get('email').toLowerCase().match(pattern) ||
      @get('name').match(pattern)
    catch
      false


  displayLangs: (->
    @get('languages').split(',').map((l) -> l.toUpperCase()).join(', ')
  ).property('languages')


  displaySkills: (->
    @get('skills').split(',').map((l) -> l.capitalize())
                  .join(', ').replace(/_booking/g, 'Book')
  ).property('skills')


  isCallable: (->
    @get('activity') == 'silent' && @get('visibility') == 'online'
  ).property('activity', 'visibility')
})
