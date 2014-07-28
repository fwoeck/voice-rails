window.DragNDrop = Ember.Namespace.create()


DragNDrop.cancel = (e) ->
  e.preventDefault()
  false


DragNDrop.Dragable = Ember.Mixin.create {

  attributeBindings: 'draggable'
  draggable: 'true'

  dragStart: (e) ->
    e.dataTransfer.effectAllowed = 'move'
    e.dataTransfer.setData 'Text', "#{@elId()}.#{@elClass()}"
    @dragStartCallback(e)

  elId: ->
    @get('model.id') || 'new'

  elClass: ->
    cstr = @get('model.constructor') || @get('constructor')
    cstr.toString().match(/[^.]+$/)[0].underscore()

  dragStartCallback: (e) ->
    # Implement me in your class
    true

}


DragNDrop.Droppable = Ember.Mixin.create {

  dragEnter: DragNDrop.cancel
  dragLeave: DragNDrop.cancel
  dragOver:  DragNDrop.cancel

  drop: (e) ->
    e.preventDefault()

    id = e.originalEvent.dataTransfer.getData('Text')
    @dragStopCallback(e, id)

  dragStopCallback: ->
    # Implement me in your class
    false

}
