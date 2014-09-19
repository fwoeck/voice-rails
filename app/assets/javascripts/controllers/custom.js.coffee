Voice.CustomController = Ember.ObjectController.extend({

  needs:         ['customers']
  contentBinding: 'controllers.customers.firstObject'
})
