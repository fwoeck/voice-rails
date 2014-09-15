Ember.HistoryTagsInput = Ember.TextField.extend({

  classNameBindings: [':typeahead']


  placeholder: (->
    i18n.placeholder.enter_entry_tags
  ).property()


  keyUp: (evt) ->
    switch evt.which
      when 27 then @clearInput()
      when 13 then @commitInput()
    return true


  focusOut: ->
    @clearInput()
    false


  commitInput: ->
    value = @get('value')
    @get('parentView').commitInput(value) &&
      @clearInput()


  clearInput: ->
    @get('parentView').clearInput()
    @set('value', '')
})
