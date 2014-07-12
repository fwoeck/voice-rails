Voice.AgentBridgeController = Ember.ObjectController.extend({

  actions:
    hangupCall: ->
      return false unless @get 'myCall'
      $.post("/calls/#{@get 'id'}", {'_method': 'DELETE'})
      false

})
