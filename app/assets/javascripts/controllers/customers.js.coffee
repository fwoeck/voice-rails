Voice.CustomersController = Ember.ArrayController.extend({

  needs:                ['search_results']
  searchResultsBinding: 'controllers.search_results.content'

  queryParams: ['c', 'h']
  h: ''
  c: ''


  init: ->
    @_super()
    @setCurrentCustomer()


  setCurrentCustomer: (->
    customer = Voice.get('allCustomers.firstObject')
    if customer != Voice.get('currentCustomer')
      Voice.set('currentCustomer', customer)
  ).observes('Voice.allCustomers.firstObject')
})
