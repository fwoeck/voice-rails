Voice.CustomerView = Ember.View.extend({

  didInsertElement: ->
    Ember.run.later @, (->
      app.resetScrollPanes()
      ($ '#customer').removeClass('hidden')
    ), 1000
})


Voice.CurrentCustomerView = Voice.CustomerView.extend({
})
