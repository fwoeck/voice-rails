Voice.MySettingsController = Ember.ObjectController.extend({

  needs: ['users']
  modelBinding: Ember.Binding.oneWay 'Voice.currentUser'


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
    Ember.run =>
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
      app.showReloadDialog()
  ).observes('useWebRtc')


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
        ), 200


  currentStatusLine: (->
    cont  = @get('content')
    act   = cont.get('activity')
    avail = cont.get('availability')
    name  = (if cont.get('isCallable') then avail else act)

    i18n.status[name] + '.'
  ).property('content.{availability,isCallable}')
})
