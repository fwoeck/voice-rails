Voice.DialogView = Ember.View.extend({

  didInsertElement: ->
    @positionPanel()


  positionPanel: ->
    el = @$('.panel')
    dx = Math.floor el.width()/2
    dy = Math.floor el.height()/2

    el.css(
      'margin-left': -dx,
      'margin-top':  -dy,
      'visibility':  'visible'
    )


  willClearRender: ->
    app.hideTooltips().then =>
      return unless @get('state') == 'inDOM'

      if @get('controller.autocomplete')
        @$('input').typeahead('destroy')


  triggerRerender: ( ->
    if @get('controller.isActive')
      ($ '#main').addClass('blurred')
      Ember.run.scheduleOnce 'afterRender', @, @resetInput
    else
      ($ '#main').removeClass('blurred')

    @rerender()
  ).observes('controller.isActive')


  resetInput: ->
    if @get('controller.requiresInput')
      @$('input[tabindex="2"]').focus()

      unless @get('controller.autocomplete')
        app.resetAbide()
    else
      app.focusDefaultTabindex()


  focusIn: ->
    return unless @get('controller.autocomplete')
    @$('form').removeClass('error')


  focusOut: ->
    ctrl = @get('controller')
    if ctrl.get('text') && ctrl.get('autocomplete')
      Ember.run.later @, ( =>
        @performManualValidation()
      ), 1

    return false


  performManualValidation: ->
    return if @$('span.tt-dropdown-menu:visible').length > 0
    ctrl = @get('controller')
    text = ctrl.get('text')

    if text && ctrl.get('validatesEmail')
      if app.strippedEmail(text)
        @$('form').removeClass('error')
      else
        @$('form').addClass('error')

})
