Voice.CurrentTagsController = Ember.ObjectController.extend({

  needs: ['customer']

  customerBinding: 'controllers.customer.content'
  contentBinding:  'customer.orderedEntries.firstObject'
})
