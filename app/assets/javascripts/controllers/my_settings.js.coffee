Voice.MySettingsController = Ember.ObjectController.extend({

  needs:          ['users']
  contentBinding:  'Voice.currentUser'


  init: ->
    @_super()
    @set 'useWebRtc', app.loadLocalKey('useWebRtc')


  storePrefs: (->
    value = @get 'useWebRtc'
    if value != app.loadLocalKey('useWebRtc')
      app.storeLocalKey 'useWebRtc', value
  ).observes('useWebRtc')


  saveOnUpdate: (->
    Ember.run.later(@, @saveCurrentUser, 50)
  ).observes('content.{availability,skills,languages}')


  saveCurrentUser: ->
    cu = Voice.get('currentUser')
    cu.save() if cu.get('currentState.stateName') != 'root.loaded.saved'


  currentStatusLine: (->
    avail = @get('content.availability')
    state = @get('content.agentState')
    name  = (if state == 'talking' then state else avail)
    if name == 'ready'
      name = 'ready to take calls'
    else
      name = "currently #{name}"

    "I'm #{name}."
  ).property('content.{availability,agentState}')
})
