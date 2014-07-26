Voice.AgentOverviewController = Ember.ArrayController.extend({

  needs: ['calls', 'users']
  contentBinding: 'controllers.users'


  actions:
    dialTo: (agent) ->
      state = agent.get('agentState')

      if Voice.get('currentUser') == agent
        @hangupCall() if state == 'talking'
      else
        @call(agent) if state == 'registered'

      false


  # FIXME This works on calls made over WebRTC only.
  #       We have to route all calls via Ahn to be
  #       able to control them with call.hangup():
  #
  hangupCall: ->
    app.dialog(
      'Do you want to hangup the current call?', 'question'
    ).then ( ->
      phone.app.hangup(phone.app.calls[0]?.id)
    ), (->)


  call: (agent) ->
    app.dialog(
      "Do you want to call #{agent.get 'displayName'}?", 'question'
    ).then ( ->
      agent.call()
    ), (->)


  currentStatusLine: (->
    available = @get('content.availableAgents')
    online    = @get('content.onlineAgents')
    agents    = if online == 1 then 'agent is' else 'agents are'
    are       = if available == 1 then 'is' else 'are'

    "#{online} #{agents} online — #{available} #{are} available."
  ).property('content.{availableAgents,onlineAgents}')

})
