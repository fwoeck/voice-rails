Voice.CustomerController = Ember.ObjectController.extend({

  contentBinding: 'parentController.customers.firstObject'


  actions:
    storeRecord: ->
      @get('content')?.save()
      false


  dirty: (->
    @get('content.currentState.stateName') != 'root.loaded.saved'
  ).property('content.currentState.stateName')
})
