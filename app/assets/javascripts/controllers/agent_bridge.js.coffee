Voice.AgentBridgeController = Ember.ObjectController.extend({

  actions:
    hangupCall: ->
      return false unless @get('myCallLeg')

      app.dialog('Do you want to hangup this call?', 'question', 'Hangup', 'Cancel').then (=>
        @get('model').hangup()
      ), (->)
      false
})
