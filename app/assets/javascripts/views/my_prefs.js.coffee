Voice.MyPrefsView = Ember.View.extend({

  didInsertElement: ->
    @set 'controller.formEl', @$()
    app.resetAbide()
})
