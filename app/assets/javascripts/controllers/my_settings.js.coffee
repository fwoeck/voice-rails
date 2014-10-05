Voice.MySettingsController = Ember.ObjectController.extend({

  needs: ['users']
  modelBinding: 'Voice.currentUser'


  init: ->
    @_super()
    @restoreLocalSettings()


  skillPartials: (->
    Ember.keys(env.skills).map (skill) -> "skills/#{skill}"
  ).property()


  languagePartials: (->
    Ember.keys(env.languages).map (lang) -> "languages/#{lang}"
  ).property()


  availabilityPartials: (->
    Ember.keys(env.availability).map (avail) -> "availability/#{avail}"
  ).property()


  restoreLocalSettings: ->
    Ember.run.next =>
      @set 'useWebRtc',    app.loadLocalKey('useWebRtc')
      @set 'useAutoReady', app.loadLocalKey('useAutoReady')


  toggleAutoReady: (->
    value = @get 'useAutoReady'
    app.storeLocalKey('useAutoReady', value)
  ).observes('useAutoReady')


  toggleWebRtc: (->
    value = @get 'useWebRtc'
    if value != app.loadLocalKey('useWebRtc')
      app.storeLocalKey('useWebRtc', value)
      Ember.run.later @, (-> @showReloadDialog value), 500
  ).observes('useWebRtc')


  showReloadDialog: (value) ->
    app.dialog(
      i18n.dialog.reload_necessary, 'question',
      i18n.dialog.reload, i18n.dialog.cancel
    ).then (->
      window.location.reload()
    ), (->)


  saveOnUpdate: (->
    Ember.run.scheduleOnce 'afterRender', @, @saveCurrentUser
  ).observes('content.{availability,skills.[],languages.[]}')


  saveCurrentUser: ->
    self = @
    cu   = Voice.get('currentUser')

    if cu.get('isDirty')
      @set('lockedForUpdate', true)
      cu.save().then ->
        Ember.run.later @, (->
          self.set('lockedForUpdate', false)
        ), 300


  currentStatusLine: (->
    cont  = @get('content')
    act   = cont.get('activity')
    avail = cont.get('availability')
    name  = (if cont.get('isCallable') then avail else act)

    i18n.status[name] + '.'
  ).property('content.{availability,isCallable}')
})
