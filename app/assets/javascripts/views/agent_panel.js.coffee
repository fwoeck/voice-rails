Voice.AgentPanelView = Ember.View.extend({

  agentsViewBinding: 'Voice.agentsView'


  actions:
    editAgent: ->
      app.setCurrentAgentForm @$()
      false


  observeActiveForm: (->
    cur = @get('controller.formIsActive')
    eql = @get('agentsView.currentForm')[0] == @$()[0]

    if eql != cur
      @set('controller.formIsActive', eql)
  ).observes('agentsView.currentForm')
})
