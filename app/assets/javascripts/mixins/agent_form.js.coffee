Voice.AgentForm = Ember.Mixin.create({

  needs:     ['agents', 'users']
  formEl:    null
  uiLocales: env.uiLocales


  actions:
    noop: ->
      false

    safeRecord: ->
      if @get('dirty')
        @validateForm()
        Ember.run.next @, @submitForm
      false

    cancelChanges: ->
      @resetForm()
      false


  init: ->
    @_super()
    @initAttributeArrays()
    @setAttributeArrays()


  initAttributeArrays: ->
    @set 'roleArray',     Ember.A()
    @set 'skillArray',    Ember.A()
    @set 'languageArray', Ember.A()


  validateForm: ->
    @get('formEl').find('form').trigger('validate.fndtn.abide')


  dirty: (->
    agent = @get('model')
    agent && agent.get('isDirty')
  ).property('model.isDirty')


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
      model.remove()
      @set 'model', @store.createRecord(Voice.User)
    else
      model.rollback()
      model.reloadOnLocaleUpdate()


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
    all = @get("model.#{attr}s") || []
    arr = selection.filter (n) -> all.indexOf(n.id) > -1
    old = @get("#{attr}Array")
    @set("#{attr}Array", arr) if Ember.compare(old, arr)


  serializeArray: (attr) ->
    arr = @get("#{attr}Array").map((n) -> n.id).sort()
    old = @get("model.#{attr}s")
    @set("model.#{attr}s", arr) if Ember.compare(old, arr)


  setRoleArray: (->
    @setArray('role', env.roleSelection)
  ).observes('model.roles.[]')


  observeRoleArray: (->
    @serializeArray('role')
  ).observes('roleArray.[]')


  setSkillArray: (->
    @setArray('skill', env.skillSelection)
  ).observes('model.skills.[]')


  observeSkillArray: (->
    @serializeArray('skill')
  ).observes('skillArray.[]')


  setLanguageArray: (->
    @setArray('language', env.languageSelection)
  ).observes('model.languages.[]')


  observeLanguageArray: (->
    @serializeArray('language')
  ).observes('languageArray.[]')
})
