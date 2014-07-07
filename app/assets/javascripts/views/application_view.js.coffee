Voice.ApplicationView = Ember.View.extend({

  templateName: 'application'

  didInsertElement: ->
    $(document).foundation()
    setupInterface()
    setupSSE()

})
