Voice.MySettingsController = Ember.ObjectController.extend({

  needs:              ['users']
  contentBinding:      'Voice.currentUser'
  availabilityBinding: 'content.availability'


  saveOnUpdate: (->
    if @get('content.currentState.stateName') != 'root.loaded.saved'
      Ember.run.scheduleOnce('actions', @, @saveCurrentUser)
  ).observes('content.{availability,skills,languages}')


  saveCurrentUser: ->
    Voice.get('currentUser').save()
})
