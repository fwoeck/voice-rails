Voice.AgentTableView = Ember.View.extend({

  actions:
    expandPane: ->
      ($ '.agent_form_wrapper').removeClass('expanded')
      @$().find('.agent_form_wrapper').addClass('expanded')
})
