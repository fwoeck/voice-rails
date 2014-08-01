Voice.CustomerController = Ember.ObjectController.extend({

  contentBinding: 'parentController.customers.firstObject'


  actions:
    storeRecord: ->
      @get('content').save()
      false
})
