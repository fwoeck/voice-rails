Voice.AgentBridgeController = Ember.ObjectController.extend({

  actions:
    hangupCall: ->
      return false unless @get('myCall')
      callId = @get('id')

      app.dialog('Do you want to hangup this call?', 'question', 'Hangup', 'Cancel').then (->
        $.post("/calls/#{callId}", {'_method': 'DELETE'})
      ), (->)
      false

})
