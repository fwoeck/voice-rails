Voice.AgentView = Ember.View.extend(DragNDrop.Droppable, {

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
    if agent != Voice.get('currentUser') && agent.get('agentState') == 'registered'
      app.dialog(
        "Do you want to transfer this call to<br /><strong>#{agent.get 'displayName'}</strong>?",
        'question', 'Transfer', 'Cancel'
      ).then ( ->
        call.transfer(agent.get 'name')
      ), (->)
    else
      return true

})
