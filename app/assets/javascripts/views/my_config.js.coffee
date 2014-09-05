Voice.MyConfigView = Ember.View.extend({

  didInsertElement: ->
    @set 'controller.formEl', @$()
    app.resetAbide()


  actions:
    expandPane: ->
      app.setCurrentAgentForm @$()
      false
})
