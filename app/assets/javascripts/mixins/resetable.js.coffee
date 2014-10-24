Voice.Resetable = Ember.Mixin.create({

  # FIXME This is extremely hacky: parts of the save-
  #       function are being used. Is there a better way?
  #
  #
  markAsSaved: ->
    @_inFlightAttributes = @_attributes
    @_attributes = {}

    @adapterWillCommit()
    @adapterDidCommit()


  remove: ->
    if !@get('isDeleted')
      @deleteRecord()
      @markAsSaved()
})
