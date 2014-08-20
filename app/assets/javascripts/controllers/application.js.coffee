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
      app.showDefaultError(i18n.dialog.browser_warning
        .replace('FIREFOX', env.firefoxVers)
        .replace('CHROME', env.chromeVers)
      )


  browserIsSupported: ->
    navigator.userAgent.match(/Chrome\/(3.)/)?[1] >= env.chromeVers ||
      navigator.userAgent.match(/Firefox\/(3.)/)?[1] >= env.firefoxVers


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
