Voice.AgentBridgeView = Ember.View.extend(DragNDrop.Dragable, {

  draggable: 'false'


  didInsertElement: ->
    app.initFoundation()


  willDestroyElement: ->
    tooltip = @$('span.has-tip').attr('data-selector')
    ($ "span.tooltip[data-selector='#{tooltip}']").remove()


  elId: ->
    @get('controller.model.origin.id')


  dragStartCallback: (e) ->
    return false unless @get('controller.myCallLeg')
    return true
})
