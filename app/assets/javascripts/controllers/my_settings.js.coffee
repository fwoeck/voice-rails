Voice.MySettingsController = Ember.ObjectController.extend({
  needs:         ['users']
  contentBinding: 'Voice.currentUser'
})