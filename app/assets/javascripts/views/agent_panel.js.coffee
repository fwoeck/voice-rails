Voice.AgentPanelView = Ember.View.extend({

  agentsViewBinding: 'Voice.agentsView'


  actions:
    editAgent: ->
      app.setCurrentAgentForm @$()
      false


  observeActiveForm: (->
    old = @get('controller.formIsActive')
    act = @get('agentsView.currentForm')?[0] == @$()[0]
    return if act == old

    if act
      @expandForm()
    else
      @collapseForm()
  ).observes('agentsView.currentForm')


  collapseForm: ->
    Ember.run.later @, (->
      @set('controller.formIsActive', false)
    ), 1000


  expandForm: ->
    @set('controller.formIsActive', true)
})
