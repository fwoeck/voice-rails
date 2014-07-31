Voice.ApplicationController = Ember.Controller.extend({

  needs: ['calls', 'users', 'chatMessages']
  allCallsBinding: 'Voice.allCalls'


  setCurrentCall: ( ->
    calls = @get('allCalls')
    return false unless calls

    cc = calls.find (call) -> call.get('myCall')
    newCall = cc?.get('origin')

    if newCall != Voice.get('currentCall')
      Voice.set('currentCall', newCall)
  ).observes('allCalls.@each.{myCall,origin}')
})
