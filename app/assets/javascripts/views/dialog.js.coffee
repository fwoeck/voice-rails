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
    app.hideTooltips()


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
      app.resetAbide()
    else
      app.focusDefaultTabindex()


  focusIn: ->
    @$('form').removeClass('error')


  focusOut: ->
    return false

})
