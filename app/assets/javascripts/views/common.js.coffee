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
  template: Ember.Handlebars.compile("{{unbound fromNow createdAt}}")
})


Ember.QueuedAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{unbound fromNow queuedAt}}")
})


Ember.CalledAt = Ember.FromNow.extend({
  template: Ember.Handlebars.compile("{{unbound fromNow calledAt}}")
})


Ember.PassConf = Ember.TextField.extend({
  attributeBindings: ['name', 'type', 'value', 'data-equalto', 'pattern']
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

  type:      'text'
  name:      'agent_search'
  maxlength: '16'

  placeholder: (->
    i18n.placeholder.find_an_agent
  ).property()

  focusIn: ->
    app.showAgentOverview()
})


Ember.HistoryTagsInput = Ember.TextField.extend({
})
