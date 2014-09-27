Voice.CustomersController = Ember.ArrayController.extend({

  needs:               ['search_results']
  searchResultsBinding: 'controllers.search_results.content'

  historySearch:  ''
  customerSearch: ''


  init: ->
    @_super()
    @setCurrentCustomer()


  searchExamplePartial: (->
    "search_examples_#{env.locale}"
  ).property()
  

  setCurrentCustomer: (->
    customer = Voice.get('allCustomers.firstObject')
    if customer != Voice.get('currentCustomer')
      Voice.set('currentCustomer', customer)
  ).observes('Voice.allCustomers.firstObject')
})
