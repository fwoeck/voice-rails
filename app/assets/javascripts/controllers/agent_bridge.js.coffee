Voice.AgentBridgeController = Ember.ObjectController.extend({

  actions:
    hangupCall: ->
      # FIXME Can we use app.hangupCurrentCall here?
      #
      return false unless @get('myCallLeg')
      app.hangupCall(@get 'model')
      false
})
