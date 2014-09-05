Voice.AgentsView = Ember.View.extend({

  classNameBindings: ['asAdmin']
  currentForm:       null
  oldForm:           null


  init: ->
    @_super()
    Voice.set('agentsView', @)


  asAdmin: (->
    @get('controller.cuIsAdmin')
  ).property('controller.cuIsAdmin')


  slideAgentForms: (->
    oldF = @get('oldForm')
    curF = @get('currentForm')
    return if oldF == curF

    app.expandAgentForm(oldF, curF)
    @set('oldForm', curF)
  ).observes('currentForm')
})
