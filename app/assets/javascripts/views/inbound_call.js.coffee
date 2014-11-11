Voice.InboundCallView = Ember.View.extend({

  didInsertElement: ->
    app.resetScrollPanes()
    app.initFoundation()


  willDestroyElement: ->
    app.resetScrollPanes()
    app.cleanupTooltips(@)
})
