Voice.AgentBridgeController = Ember.ObjectController.extend({

  actions:
    hangupCall: ->
      return false unless @get('myCallLeg')
      app.hangupCall(@get 'model')
      false
})
