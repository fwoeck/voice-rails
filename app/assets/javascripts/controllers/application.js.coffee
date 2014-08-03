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
    unless navigator.userAgent.match(/Chrome\/(3.)/)?[1] >= env.chromeVersion
      app.showDefaultError("For now, Chrome #{env.chromeVersion}+ is the only supported browser. Use this platform at own risk.")


  setCurrentCall: ( ->
    myCall  = @getMyCall()
    newCall = myCall?.get('bridge')

    if newCall != Voice.get('currentCall')
      Voice.set('currentCall', newCall)
  ).observes('allCalls.@each.{myCallLeg,bridge}')
})
