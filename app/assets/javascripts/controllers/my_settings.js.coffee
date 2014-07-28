Voice.MySettingsController = Ember.ObjectController.extend({

  needs:          ['users']
  contentBinding:  'Voice.currentUser'


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
