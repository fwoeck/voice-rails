Voice.MySettingsController = Ember.ObjectController.extend({

  needs:          ['users']
  contentBinding:  'Voice.currentUser'


  init: ->
    @_super()
    @restoreWebRtcSetting()


  skillPartials: (->
    Ember.keys(env.skills).map (skill) -> "skills/#{skill}"
  ).property()


  languagePartials: (->
    Ember.keys(env.languages).map (lang) -> "languages/#{lang}"
  ).property()


  availabilityPartials: (->
    Ember.keys(env.availability).map (avail) -> "availability/#{avail}"
  ).property()


  restoreWebRtcSetting: ->
    Ember.run.next =>
      @set 'useWebRtc', app.loadLocalKey('useWebRtc')


  storePrefs: (->
    value = @get 'useWebRtc'
    if value != app.loadLocalKey('useWebRtc')
      app.storeLocalKey 'useWebRtc', value
  ).observes('useWebRtc')


  saveOnUpdate: (->
    state = @get('content.currentState.stateName')
    if state == 'root.loaded.updated.uncommitted'
      Ember.run.scheduleOnce 'afterRender', @, @saveCurrentUser
  ).observes('content.{availability,skills,languages}')


  saveCurrentUser: ->
    cu = Voice.get('currentUser')
    cu.save() if cu.get('currentState.stateName') != 'root.loaded.saved'


  currentStatusLine: (->
    cont  = @get('content')
    act   = cont.get('activity')
    avail = cont.get('availability')
    name  = (if cont.get('isCallable') then avail else act)

    if name == 'ready'
      name = 'ready to take calls'
    else
      name = "currently #{name}"

    "I'm #{name}."
  ).property('content.{availability,isCallable}')
})
