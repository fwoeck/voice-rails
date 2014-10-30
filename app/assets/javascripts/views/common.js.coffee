Voice.RadioButtonView = Ember.View.extend({

  attributeBindings: ['name', 'type', 'value', 'checked:checked:']
  tagName:            'input'
  type:               'radio'

  init: ->
    @_super()
    @on 'change', -> @set 'selection', @$().val()

  checked: (->
    @get('value') == @get('selection')
  ).property('selection')
})


Voice.CheckmarkView = Ember.View.extend({

  attributeBindings: ['name', 'type', 'value', 'checked:checked:']
  tagName:            'input'
  type:               'checkbox'

  init: ->
    @_super()
    @on 'change', -> @set 'selection', @$().prop('checked')

  checked: (->
    @get('selection')
  ).property('selection')
})


Voice.FromNowView = Ember.View.extend({

  tagName: 'span'

  didInsertElement: ->
    self = @
    @interval = window.setInterval (->
      self.rerender()
    ), 5000

  willClearRender: ->
    window.clearInterval @interval
})


Voice.CreatedAtView = Voice.FromNowView.extend({
  template: Ember.Handlebars.compile("{{unbound fromNow createdAt}}")
})


Voice.QueuedAtView = Voice.FromNowView.extend({
  template: Ember.Handlebars.compile("{{unbound fromNow queuedAt}}")
})


Voice.CalledAtView = Voice.FromNowView.extend({
  template: Ember.Handlebars.compile("{{unbound fromNow calledAt}}")
})


Voice.PassConfView = Ember.TextField.extend({
  attributeBindings: ['name', 'type', 'value', 'data-equalto', 'pattern']
})


Voice.TextFieldView = Ember.TextField.extend({

  keyUp: (evt) ->
    switch evt.which
      when 27 then @clearInput()
    return true

  clearInput: ->
    @set('value', '')
})


Voice.AgentSearchView = Voice.TextFieldView.extend({

  type:      'text'
  name:      'agent_search'
  maxlength: '16'

  placeholder: (->
    i18n.placeholder.find_an_agent
  ).property()

  focusIn: ->
    app.showAgentOverview()
})
