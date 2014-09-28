Voice.GeneralSearch = Ember.TextField.extend({

  type:      'text'
  maxlength: '128'


  keyUp: (evt) ->
    switch evt.which
      when 27 then @clearSearch()
      when 13 then @startSearch()
    return true


  clearSearch: ->
    @get('parentView.controller').clearResultSet()
    @set('value', '')


  startSearch: ->
    @get('parentView.controller').startSearch()
})


Voice.CustomerSearch = Voice.GeneralSearch.extend({

  name: 'customer_search'

  didInsertElement: ->
    @startSearch()

  placeholder: (->
    i18n.placeholder.find_customers
  ).property()
})


Voice.HistorySearch = Voice.GeneralSearch.extend({

  name: 'history_search'

  placeholder: (->
    i18n.placeholder.find_calls
  ).property()
})


Voice.SearchLimit = Voice.GeneralSearch.extend({

  name: 'search_limit'

  placeholder: (->
    i18n.placeholder.enter_timespan
  ).property()
})
