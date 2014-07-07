Ember.RadioButton = Ember.View.extend({

  attributeBindings: ['name', 'type', 'value', 'checked:checked:']
  tagName:            'input'
  type:               'radio'

  click: ->
    @set 'selection', @$().val()
    Voice.get('currentUser').save()

  checked: (->
    @get('value') == @get('selection')
  ).property()

})
