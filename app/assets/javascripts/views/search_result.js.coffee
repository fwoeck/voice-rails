Voice.SearchResultView = Ember.View.extend({
})


Voice.SearchResultEntryView = Ember.View.extend({

  didInsertElement: ->
    app.resetScrollPanes()
    app.initFoundation()


  willDestroyElement: ->
    app.resetScrollPanes()
    app.cleanupTooltips(@)
})
