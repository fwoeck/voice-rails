Voice.ApplicationController = Ember.Controller.extend({

  needs: ['calls', 'users', 'chatMessages']
  allCallsBinding: 'Voice.allCalls'


  init: ->
    @_super()
    @setCurrentCall()
    Ember.run.next @, @displayBrowserWarning


  getMyCall: ->
    calls = @get('allCalls')
    return false unless calls

    calls.find (call) -> call.get('myCallLeg')


  displayBrowserWarning: ->
    unless @browserIsSupported()
      app.showDefaultError("For now, Chrome #{env.chromeVersion}+ and Firefox #{env.firefoxVersion}+ are the only supported browsers. Make sure, your platform delivers WebRTC and SSE.")


  browserIsSupported: ->
    navigator.userAgent.match(/Chrome\/(3.)/)?[1] >= env.chromeVersion ||
      navigator.userAgent.match(/Firefox\/(3.)/)?[1] >= env.firefoxVersion


  setCurrentCall: (->
    myCall  = @getMyCall()
    newCall = myCall?.get('bridge')

    if newCall != Voice.get('currentCall')
      Voice.set('currentCall', newCall)
  ).observes('allCalls.@each.{myCallLeg,bridge}')


  setCurrentPath: (->
    Voice.set 'currentPath', @get('currentPath')
  ).observes('currentPath')
})
