Voice.CallsController = Ember.ArrayController.extend({

  init: ->
    @_super()
    @bundlePairs()
    @setupCallWiper()


  setupCallWiper: ->
    unless @timer
      @timer = window.setInterval (=> @wipeHungupCalls()), 3000


  wipeHungupCalls: ->
    Ember.run =>
      @get('model').forEach (call) ->
        call.remove() if call.readyForWipe()


  bundlePairs: ( ->
    @get('model').forEach (bridge) =>
      cTag = bridge.get('callTag')
      oId  = bridge.get('originId')
      return unless oId && cTag

      if (origin = @store.getById 'call', oId)
        @connectBridgeTo(origin, bridge)
        @setCurrentCall(bridge) if @tagMatches(origin, cTag)
  ).observes('model.@each.{originId,callTag}')


  tagMatches: (origin, cTag) ->
    origin && origin.get('callTag') == cTag


  connectBridgeTo: (origin, bridge) ->
    return if !origin || bridge.get('origin') == origin
    origin.set('bridge', bridge)
    bridge.set('origin', origin)


  setCurrentCall: (call) ->
    if @callIsNewCurrent(call)
      app.closeCurrentCall(true)
      app.setAvailability('busy')

      Ember.run.later @, (->
        Voice.set('currentCall', call)
        Voice.outboundCall = false
      ), 500


  callIsNewCurrent: (call) ->
    call != Voice.get('currentCall') &&
      call.get('myCallLeg') && !call.get('hungupAt')
})
