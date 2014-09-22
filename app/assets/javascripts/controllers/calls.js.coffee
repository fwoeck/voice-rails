Voice.CallsController = Ember.ArrayController.extend({

  init: ->
    @_super()
    @bundlePairs()


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
