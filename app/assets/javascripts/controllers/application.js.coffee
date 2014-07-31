Voice.ApplicationController = Ember.Controller.extend({

  needs: ['calls', 'users', 'chatMessages']
  allCallsBinding: 'Voice.allCalls'


  getMyCall: ->
    calls = @get('allCalls')
    return false unless calls

    calls.find (call) -> call.get('myCallLeg')


  setCurrentCall: ( ->
    myCall  = @getMyCall()
    newCall = myCall?.get('bridge')

    if newCall != Voice.get('currentCall')
      Voice.set('currentCall', newCall)
  ).observes('allCalls.@each.{myCallLeg,bridge}')
})
