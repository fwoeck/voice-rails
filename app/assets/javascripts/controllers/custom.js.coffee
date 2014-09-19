Voice.CustomController = Ember.ObjectController.extend({

  needs:               ['customers', 'search_results']
  contentBinding:       'controllers.customers.firstObject'
  searchResultsBinding: 'controllers.search_results.content'
})
