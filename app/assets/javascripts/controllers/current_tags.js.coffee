Voice.CurrentTagsController = Ember.ObjectController.extend({

  customerBinding: Ember.Binding.oneWay 'Voice.currentCustomer'
  modelBinding:    Ember.Binding.oneWay 'customer.orderedEntries.firstObject'
})
