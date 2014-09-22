Voice.CustomerSearch = Ember.TextField.extend({

  type:      'text'
  name:      'customer_search'
  maxlength: '128'

  placeholder: (->
    i18n.placeholder.find_customers
  ).property()

  keyUp: (evt) ->
    switch evt.which
      when 27 then @clearSearch()
      when 13 then @startSearch()
    return true

  clearSearch: ->
    @clearResultSet()
    @set('value', '')
    
  startSearch: ->
    @clearResultSet()
    term = @get('value').trim().toLowerCase()
    Voice.store.findQuery('searchResult', {q: term})

  clearResultSet: ->
    Voice.store.unloadAll('searchResult')
})
