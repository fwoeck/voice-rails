Voice.AgentsView = Ember.View.extend({

  classNameBindings: ['asAdmin']


  asAdmin: (->
    @get('controller.cuIsAdmin')
  ).property('controller.cuIsAdmin')
})
