Voice.AgentPanelView = Ember.View.extend({

  agentsViewBinding: 'Voice.agentsView'
  slideTimer:         null


  actions:
    editAgent: ->
      return unless @get('controller.cuCanEditAgent')
      app.setCurrentAgentForm @$()
      false


  observeActiveForm: (->
    old = @get('controller.formIsActive') && !@get('slideTimer')
    act = @get('agentsView.currentForm')?[0] == @$()[0]
    return if act == old

    if act
      @expandForm()
    else
      @collapseForm()
  ).observes('agentsView.currentForm')


  collapseForm: ->
    @set 'slideTimer', Ember.run.later(@, (->
      @set('controller.formIsActive', false)
    ), 1000)


  expandForm: ->
    timer = @get('slideTimer')
    if timer
      Ember.run.cancel timer
      @set 'slideTimer', null

    @set('controller.formIsActive', true)
})
