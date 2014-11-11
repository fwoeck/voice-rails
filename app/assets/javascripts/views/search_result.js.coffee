Voice.SearchResultView = Ember.View.extend({

  didInsertElement: ->
    app.resetScrollPanes()
    app.initFoundation()
})


Voice.SearchResultEntryView = Ember.View.extend({

  willDestroyElement: ->
    app.resetScrollPanes()
    app.cleanupTooltips(@)
})
