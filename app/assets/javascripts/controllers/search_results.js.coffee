Voice.SearchResultsController = Ember.ArrayController.extend({
})


Voice.SearchResultController = Ember.ObjectController.extend({
})


Voice.SearchResultEntryController = Ember.ObjectController.extend({

  actions:
    gotoCustomer: ->
      customerId = @get 'parentController.content.id'
      @transitionToRoute 'customer', customerId
})
