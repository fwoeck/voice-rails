Voice.AgentBridgeView = Ember.View.extend(DragNDrop.Dragable, {

  didInsertElement: ->
    @$().foundation()

    # FIXME This is ugly:
    #
    if navigator.appVersion.indexOf('Chrome/') != -1
      @$('.connection').css(padding: '4px 5px')


  willDestroyElement: ->
    tooltip = @$('span.has-tip').attr('data-selector')
    ($ "span.tooltip[data-selector='#{tooltip}']").remove()


  elId: ->
    @get('controller.model.origin.id')


  dragStartCallback: (e) ->
    return false unless @get('controller.myCall')
    return true

})
