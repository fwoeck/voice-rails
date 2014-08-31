Voice.MyPrefsView = Ember.View.extend({

  didInsertElement: ->
    @set 'controller.formEl', @$()
    app.resetAbide()


  actions:
    expandPane: ->
      ($ '.agent_form_wrapper').removeClass('expanded')
      @$().find('.agent_form_wrapper').addClass('expanded')
})
