Voice.MyPrefsController = Ember.ObjectController.extend({

  actions:

    noop: ->
      false

    safeRecord: ->
      @get('model').save()
      false

    cancelChanges: ->
      @get('model').rollback()
      false


  skillSelection: (->
    env.skillSelection
  ).property()


  languageSelection: (->
    env.languageSelection
  ).property()


  roleSelection: (->
    env.roleSelection
  ).property()
})
