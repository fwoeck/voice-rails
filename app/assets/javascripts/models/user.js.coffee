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


  # FIXME This establishes a direct call via WebRTC.
  #       These calls are not routed via Ahn and are
  #       thus not controllable by it.
  #       See:
  #       Adhearsion::OutboundCall.originate 'SIP/103', from: 'SIP/102', controller: DirectContext
  #
  call: ->
    phone.app.call(@get 'name')


  displayName: (->
    @get('fullname') || @get('email')
  ).property('fullname')


  displayLangs: (->
    @get('languages').split(',').map((l) -> l.toUpperCase()).join(', ')
  ).property('languages')


  displaySkills: (->
    @get('skills').split(',').map((l) -> l.capitalize())
                  .join(', ').replace(/_booking/g, 'Book')
  ).property('skills')

})
