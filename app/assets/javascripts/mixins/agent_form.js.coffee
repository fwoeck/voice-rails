Voice.AgentForm = Ember.Mixin.create({

  needs:         ['agents', 'users']
  formEl:        null
  roleArray:     []
  skillArray:    []
  languageArray: []


  actions:

    noop: ->
      false

    safeRecord: ->
      @validateForm()
      Ember.run.next @, @submitForm
      false

    cancelChanges: ->
      @resetForm()
      false


  init: ->
    @_super()
    @setAttributeArrays()


  validateForm: ->
    @get('formEl').find('form').trigger('validate.fndtn.abide')


  submitForm: ->
    el         = @get('formEl')
    errorCount = el.find('form div.error').length

    if errorCount == 0
      @saveAgentData(el)
    else
      app.showDefaultError(i18n.dialog.form_with_errors)


  saveAgentData: (el) ->
    spin = el.find('.fa-refresh')
    @enableSpinner(spin)

    @get('model').save().then (=>
      @clearAgent()
    ), (->)


  enableSpinner: (spin) ->
    spin.addClass('fa-spin')
    Ember.run.later @, (->
      spin.removeClass('fa-spin')
    ), 1000


  passwordId: (->
    id = @get('model.id') || 'new'
    "password-#{id}"
  ).property('model.id')


  clearAgent: ->
    model = @get('model')

    if model.get('isNew')
      model.deleteRecord()
      @set 'model', @store.createRecord(Voice.User)
    else
      model.rollback()


  resetForm: ->
    @clearAgent()
    @setAttributeArrays()
    @hideErrors()


  hideErrors: ->
    @get('formEl').find('form div.error').removeClass('error')


  setAttributeArrays: ->
    @setLanguageArray()
    @setSkillArray()
    @setRoleArray()


  skillSelection: (->
    env.skillSelection
  ).property()


  languageSelection: (->
    env.languageSelection
  ).property()


  roleSelection: (->
    env.roleSelection
  ).property()


  setArray: (attr, selection) ->
    all = @get("content.#{attr}s") || ""
    arr = selection.filter (n) -> all.match(n.id)
    @set "#{attr}Array", arr


  serializeArray: (attr) ->
    arr = @get("#{attr}Array")
    @set "content.#{attr}s", arr.map(
      (n) -> n.id
    ).sort().join(',')


  setRoleArray: (->
    @setArray('role', env.roleSelection)
  ).observes('content.roles')


  observeRoleArray: (->
    @serializeArray('role')
  ).observes('roleArray.[]')


  setSkillArray: (->
    @setArray('skill', env.skillSelection)
  ).observes('content.skills')


  observeSkillArray: (->
    @serializeArray('skill')
  ).observes('skillArray.[]')


  setLanguageArray: (->
    @setArray('language', env.languageSelection)
  ).observes('content.languages')


  observeLanguageArray: (->
    @serializeArray('language')
  ).observes('languageArray.[]')
})
