Voice.MySettingsView = Ember.View.extend({

  classNameBindings:      ['lockedForUpdate']
  lockedForUpdateBinding: Ember.Binding.oneWay 'controller.lockedForUpdate'
})
