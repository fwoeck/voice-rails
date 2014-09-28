Voice.CurrentTagsController = Ember.ObjectController.extend({

  customerBinding: 'Voice.currentCustomer'
  modelBinding:    'customer.orderedEntries.firstObject'
})
