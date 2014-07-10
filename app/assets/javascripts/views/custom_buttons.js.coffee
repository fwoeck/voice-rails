Ember.RadioButton = Ember.View.extend({

  attributeBindings: ['name', 'type', 'value', 'checked:checked:']
  tagName:            'input'
  type:               'radio'

  click: ->
    @set 'selection', @$().val()

  checked: (->
    @get('value') == @get('selection')
  ).property('selection')

})


Ember.CheckMark = Ember.View.extend({

  attributeBindings: ['name', 'type', 'value', 'checked:checked:']
  tagName:            'input'
  type:               'checkbox'

  click: ->
    @set 'selection', !@get('selection')

  checked: (->
    @get('selection')
  ).property('selection')

})


Ember.FromNow = Ember.View.extend({

  tagName:  'span'
  template:  Ember.Handlebars.compile("{{unbound fromNow call.queuedAt}}")


  didInsertElement: ->
    self = @
    @interval = window.setInterval (->
      self.rerender()
    ), 5000


  willClearRender: ->
    window.clearInterval @interval

})
