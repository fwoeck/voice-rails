Voice.MySettingsController = Ember.ObjectController.extend({

  needs:          ['users']
  contentBinding:  'Voice.currentUser'


  saveOnUpdate: (->
    Ember.run.later(@, @saveCurrentUser, 50)
  ).observes('content.{availability,skills,languages}')


  saveCurrentUser: ->
    cu = Voice.get('currentUser')
    cu.save() if cu.get('currentState.stateName') != 'root.loaded.saved'

})
