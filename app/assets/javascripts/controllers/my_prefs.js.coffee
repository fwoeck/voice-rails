Voice.MyPrefsController = Ember.ObjectController.extend({

  roleArray:     []
  skillArray:    []
  languageArray: []


  actions:

    noop: ->
      false

    safeRecord: ->
      @validateAndSaveForm()
      false

    cancelChanges: ->
      @get('model').rollback()
      @setAttributeArrays()
      false


  init: ->
    @_super()
    @setAttributeArrays()


  validateAndSaveForm: ->
    # TODO This depends on the template element.
    #      Can we pass it here from the view?
    #
    errorCount = ($ '#my_prefs form div.error:visible').length
    if errorCount == 0
      @get('model').save()
    else
      app.showDefaultError(i18n.dialog.form_with_errors)


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
    all = @get("content.#{attr}s")
    arr = selection.filter (n) -> all.match(n.id)
    @set "#{attr}Array", arr

  serializeArray: (attr) ->
    arr = @get("#{attr}Array")
    @set "content.#{attr}s", arr.map(
      (n) -> n.id
    ).sort().join(',')


  setRoleArray: ->
    @setArray('role', env.roleSelection)

  observeRoleArray: (->
    @serializeArray('role')
  ).observes('roleArray.[]')


  setSkillArray: ->
    @setArray('skill', env.skillSelection)

  observeSkillArray: (->
    @serializeArray('skill')
  ).observes('skillArray.[]')


  setLanguageArray: ->
    @setArray('language', env.languageSelection)

  observeLanguageArray: (->
    @serializeArray('language')
  ).observes('languageArray.[]')
})
