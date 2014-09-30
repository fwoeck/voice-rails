Voice.SearchResultView = Ember.View.extend({
})


Voice.SearchResultEntryView = Ember.View.extend({

  didInsertElement: ->
    app.initFoundation()


  willDestroyElement: ->
    app.cleanupTooltips(@)
})
