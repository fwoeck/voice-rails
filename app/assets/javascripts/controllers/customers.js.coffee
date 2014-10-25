Voice.CustomersController = Ember.ArrayController.extend({

  needs:                ['search_results']
  customerBinding:      Ember.Binding.oneWay 'Voice.allCustomers.firstObject'
  searchResultsBinding: Ember.Binding.oneWay 'controllers.search_results.content'

  openRequest: false
  queryParams: ['c', 'h', 't']
  t: ''
  h: ''
  c: ''


  init: ->
    @_super()
    @setCurrentCustomer()


  setCurrentCustomer: (->
    cust = @get('customer')
    if cust != Voice.get('currentCustomer')
      Voice.set('currentCustomer', cust)
  ).observes('customer')


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
