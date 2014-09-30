Voice.CrmTicketView = Ember.View.extend({

  tagName: 'tr'


  didInsertElement: ->
    app.initFoundation()


  willDestroyElement: ->
    app.cleanupTooltips(@)
})
