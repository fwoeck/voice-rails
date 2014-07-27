Voice.AgentController = Ember.ObjectController.extend({

  actions:
    dialTo: (agent) ->
      state = agent.get('agentState')
      cu    = Voice.get('currentUser')

      if state == 'talking'
        @hangupCall()
      else if state == 'registered' && cu != agent &&
              cu.get('agentState') == 'registered'
        @call(agent)

      false


  # FIXME This works on calls made over WebRTC only.
  #       We have to route all calls via Ahn to be
  #       able to control them with call.hangup().
  #       See:
  #       Adhearsion::OutboundCall.originate 'SIP/103', from: 'SIP/102', controller: DirectContext
  #
  hangupCall: ->
    app.dialog(
      'Do you want to hangup your current call?', 'question'
    ).then ( ->
      phone.app.hangup(phone.app.calls[0]?.id)
    ), (->)


  call: (agent) ->
    app.dialog(
      "Do you want to call<br /><strong>#{agent.get 'displayName'}</strong>?", 'question'
    ).then ( ->
      agent.call()
    ), (->)

})
