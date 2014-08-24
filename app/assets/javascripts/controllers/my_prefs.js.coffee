Voice.MyPrefsController = Ember.ObjectController.extend({

  actions:
    safeRecord: ->
      @get('model').save()
      false
})
