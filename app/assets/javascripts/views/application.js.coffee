Voice.ApplicationView = Ember.View.extend({

  templateName: 'application'
  classNameBindings: [':application']


  didInsertElement: ->
    Ember.run.later app, app.setupPhone, 1500
    app.setupSSE()

    window.onbeforeunload = ->
      env.sseSource.close()
      phone.app.logoff()
})
