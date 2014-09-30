Voice.AgentView = Ember.View.extend(DragNDrop.Droppable, {

  didInsertElement: ->
    app.initFoundation()


  willDestroyElement: ->
    app.cleanupTooltips(@)


  dragStopCallback: (e, el='null.null') ->
    @oe               = e.originalEvent
    [@elId, @elClass] = el.split('.')

    e.stopPropagation()
    if @elClass == 'agent_bridge_view'
      call  = Voice.store.getById('call', @elId)
      agent = @get('controller.model')
      @transferTo(agent, call) if call
    else
      return true


  transferTo: (agent, call) ->
    if agent != Voice.get('currentUser') && agent.get('isCallable')
      app.dialog(
        i18n.dialog.transfer_call.replace('AGENT', agent.get 'displayName')
        'question', i18n.dialog.transfer, i18n.dialog.cancel
      ).then ( ->
        call.transfer(agent.get 'name')
      ), (->)
    else
      return true
})
