Voice.InboundCallView = Ember.View.extend({

  didInsertElement: ->
    app.initFoundation()


  willDestroyElement: ->
    app.cleanupTooltips(@)
})
