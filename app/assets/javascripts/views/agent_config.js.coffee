Voice.AgentConfigView = Ember.View.extend({

  didInsertElement: ->
    @set 'controller.formEl', @$()
    app.resetAbide()
})
