Voice.CustomersController = Ember.ArrayController.extend({

  needs:                ['search_results']
  searchResultsBinding: 'controllers.search_results.content'

  openRequest: false
  queryParams: ['c', 'h', 't']
  t: ''
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


  startSearch: ->
    @sendSearchRequest @get('h'), @get('c'), @get('t')


  sendSearchRequest: (hist, cust, delta) ->
    @clearResultSet()
    return if @get('openRequest') || !(hist || cust)

    @set('openRequest', true)
    Voice.store.findQuery('searchResult', {c: cust, h: hist, t: delta}).then =>
      @set('openRequest', false)


  clearResultSet: ->
    Voice.store.unloadAll('searchResult')
})
