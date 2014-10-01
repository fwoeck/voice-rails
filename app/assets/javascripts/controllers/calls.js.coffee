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
      ctag = bridge.get('callTag')
      oId  = bridge.get('originId')
      return unless ctag && oId

      origin = @store.getById('call', oId)
      @connectBridgeTo(origin, bridge)
      @setCurrentCall(bridge) if @tagMatches(origin, ctag)
  ).observes('model.@each.{callTag,originId}')


  tagMatches: (origin, ctag) ->
    origin && origin.get('callTag') == ctag


  connectBridgeTo: (origin, bridge) ->
    return if !origin || bridge.get('origin') == origin
    origin.set('bridge', bridge)
    bridge.set('origin', origin)


  setCurrentCall: (call) ->
    if !call.get('hungup') && call.get('myCallLeg')
      Voice.set('currentCall', call)
      app.setAvailability('busy')
})
