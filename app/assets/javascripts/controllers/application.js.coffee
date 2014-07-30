Voice.ApplicationController = Ember.Controller.extend({

  needs: ['calls', 'users', 'chatMessages']
  allCallsBinding: 'Voice.allCalls'


  setCurrentCall: ( ->
    calls = @get('allCalls')
    return false unless calls

    cc = calls.find (call) -> call.get('myCall')
    Voice.set 'currentCall', cc?.get('origin')
  ).observes('allCalls.@each.{myCall,origin}')
})
