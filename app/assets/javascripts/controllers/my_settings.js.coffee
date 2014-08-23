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
      Ember.run.later @, (-> @showReloadDialog value), 500
  ).observes('useWebRtc')


  showReloadDialog: (value) ->
    app.storeLocalKey 'useWebRtc', value
    app.dialog(
      i18n.dialog.reload_necessary, 'question',
      i18n.dialog.reload, i18n.dialog.cancel
    ).then (->
      window.location.reload()
    ), (->)


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

    i18n.status[name]
  ).property('content.{availability,isCallable}')
})
