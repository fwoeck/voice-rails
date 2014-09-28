Voice.GeneralSearch = Ember.TextField.extend({

  type:       'text'
  maxlength:  '128'
  openRequest: false


  keyUp: (evt) ->
    switch evt.which
      when 27 then @clearSearch()
      when 13 then @startSearch()
    return true


  clearSearch: ->
    @clearResultSet()
    @set('value', '')


  sendSearchRequest: (hist, cust) ->
    @clearResultSet()
    return if @get('openRequest') || !(hist || cust)

    @set('openRequest', true)
    Voice.store.findQuery('searchResult', {c: cust, h: hist}).then =>
      @set('openRequest', false)


  clearResultSet: ->
    Voice.store.unloadAll('searchResult')
})


Voice.CustomerSearch = Voice.GeneralSearch.extend({

  name: 'customer_search'


  didInsertElement: ->
    @startSearch()


  placeholder: (->
    i18n.placeholder.find_customers
  ).property()


  startSearch: ->
    hist = @get('other')
    cust = @get('value')
    @sendSearchRequest(hist, cust)
})


Voice.HistorySearch = Voice.GeneralSearch.extend({

  name: 'history_search'


  placeholder: (->
    i18n.placeholder.find_calls
  ).property()


  startSearch: ->
    hist = @get('value')
    cust = @get('other')
    @sendSearchRequest(hist, cust)
})
