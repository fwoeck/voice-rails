Voice.ApplicationView = Ember.View.extend({

  templateName: 'application'

  didInsertElement: ->
    $(document).foundation()
    app.setupInterface()
    app.setupSSE()

})
