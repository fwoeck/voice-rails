Voice.IndexView = Ember.View.extend({

  classNameBindings: [':index']


  didInsertElement: ->
    app.setupDashboard()


  willDestroyElement: ->
    app.cleanupDashboard()
})
