Voice.NewAgentView = Ember.View.extend({

  didInsertElement: ->
    @set 'controller.formEl', @$()
    app.resetAbide()


  actions:
    expandPane: ->
      @set('controller.currentForm', null)
      app.expandAgentForm @$()
})
