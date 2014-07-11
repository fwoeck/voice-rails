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
  tagName: 'span'

  didInsertElement: ->
    self = @
    @interval = window.setInterval (->
      self.rerender()
    ), 5000

  willClearRender: ->
    window.clearInterval @interval
})


Ember.AnsweredAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{fromNow bridge.calledAt}}")
})


Ember.QueuedAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{fromNow queuedAt}}")
})


Ember.CalledAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{fromNow calledAt}}")
})


Ember.ChatInput = Ember.TextField.extend({
  placeholder: 'Type here...'
  maxlength:   '150'

  keyUp: (evt) ->
    switch evt.which
      when 13 then @sendMessage()
      when 27 then @clearInput()
    return true

  sendMessage: ->
    message = @get('value')
    if message
      Voice.ChatMessage.send(message)
      @set('value', '')

  clearInput: ->
    @set('value', '')
})
