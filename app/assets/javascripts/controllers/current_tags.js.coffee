Voice.CurrentTagsController = Ember.ObjectController.extend({

  needs:          ['customer']
  modelBinding:    'customer.orderedEntries.firstObject'
  customerBinding: 'controllers.customer.content'
})
