Voice.AgentBridgeView = Ember.View.extend(DragNDrop.Dragable, {

  draggable: 'false'


  didInsertElement: ->
    app.initFoundation()


  willDestroyElement: ->
    app.cleanupTooltips(@)


  elId: ->
    @get('controller.model.origin.id')


  dragStartCallback: (e) ->
    return false unless @get('controller.myCallLeg')
    return true
})
