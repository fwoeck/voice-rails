Voice.CallsController = Ember.ArrayController.extend({

  init: ->
    @_super()
    @bundlePairs()
    @setupCallWiper()


  setupCallWiper: ->
    unless @timer
      @timer = window.setInterval (=> @wipeHungupCalls()), 3000


  wipeHungupCalls: ->
    @get('model').forEach (call) ->
      call.remove() if call.readyForWipe()


  bundlePairs: ( ->
    @get('model').forEach (bridge) =>
      oId = bridge.get('originId')
      return unless oId

      if (origin = @store.getById 'call', oId)
        @connectBridgeTo(origin, bridge)
        @setCurrentCall(bridge)
  ).observes('model.@each.originId')


  connectBridgeTo: (origin, bridge) ->
    return if !origin || bridge.get('origin') == origin
    origin.set('bridge', bridge)
    bridge.set('origin', origin)


  setCurrentCall: (call) ->
    if @callIsNewCurrent(call)
      app.closeCurrentCall()

      Ember.run.next ->
        app.setAvailability('busy')
        Voice.set('currentCall', call)


  callIsNewCurrent: (call) ->
    call != Voice.get('currentCall') &&
      call.get('myCallLeg') && !call.get('hungup')
})
