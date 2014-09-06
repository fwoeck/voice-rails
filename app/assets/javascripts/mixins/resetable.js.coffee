Voice.Resetable = Ember.Mixin.create({

  markAsSaved: ->
    # FIXME This is extremely hacky - is there a better way?
    #
    @_attributes = {}
    @transitionTo('loaded.saved')
    false
})
