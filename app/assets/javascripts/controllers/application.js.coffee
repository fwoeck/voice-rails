Voice.ApplicationController = Ember.Controller.extend({

  needs: ['calls', 'users', 'chatMessages']

  init: ->
    @_super()
    Ember.run.next @, @displayBrowserWarning


  actions:
    showHelp: ->
      app.showShortcutList()
      false

    hangupCall: ->
      app.hangupCurrentCall()
      false


  displayBrowserWarning: ->
    unless @browserIsSupported()
      app.showDefaultError(i18n.dialog.browser_warning
        .replace('FIREFOX', env.firefoxVers)
        .replace('CHROME', env.chromeVers)
      )


  browserIsSupported: ->
    navigator.userAgent.match(/Chrome\/(3.)/)?[1] >= env.chromeVers ||
      navigator.userAgent.match(/Firefox\/(3.)/)?[1] >= env.firefoxVers


  setCurrentPath: (->
    Voice.set 'currentPath', @get('currentPath')
  ).observes('currentPath')


  iAmTalking: ( ->
    cc = Voice.get('currentCall')
    cc && !cc.get('hungup')
  ).property('Voice.currentCall.hungup')
})
