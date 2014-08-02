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


Ember.CreatedAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{fromNow createdAt}}")
})


Ember.QueuedAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{fromNow queuedAt}}")
})


Ember.CalledAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{fromNow calledAt}}")
})


Ember.ChatInput = Ember.TextField.extend({

  name:        'chat_message'
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


Ember.RemarksInput = Ember.TextField.extend({

  classNameBindings: ['dirty']
  placeholder:        'Enter remarks for this call..'
  entryBinding:       'controller.content'
  maxlength:          '250'


  dirty: (->
    @get('entry.currentState.stateName') != 'root.loaded.saved'
  ).property('entry.currentState.stateName')


  focusIn: ->
    @oldValue = @get 'value'

  focusOut: ->
    @saveRemark()
    false

  keyUp: (evt) ->
    switch evt.which
      when 13 then @leaveField()
      when 27 then @clearInput()
    return true

  leaveField: ->
    @$().blur()

  saveRemark: ->
    remarks = @get 'value'
    return false if remarks == @oldValue
    @get('entry').save()
    false

  clearInput: ->
    @set('value', @oldValue)
})


Voice.TextField = Ember.TextField.extend({

  keyUp: (evt) ->
    switch evt.which
      when 27 then @clearInput()
    return true

  clearInput: ->
    @set('value', '')
})


Voice.AgentSearch = Voice.TextField.extend({

  type:        'text'
  name:        'agent_search'
  maxlength:   '16'
  placeholder: 'Find a name..'

  focusIn: ->
    app.showAgentOverview()
})
