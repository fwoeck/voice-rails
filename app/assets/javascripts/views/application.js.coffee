Voice.ApplicationView = Ember.View.extend({

  templateName: 'application'

  didInsertElement: ->
    $(document).foundation()
    app.setupInterface()
    app.setupPhone()
    app.setupSSE()

    window.onbeforeunload = ->
      env.sseSource.close()
      phone.app.logoff()

})
