Voice.RemarksInputView = Ember.TextArea.extend({

  classNameBindings: ['dirty']
  maxlength:          '1000'


  placeholder: (->
    i18n.placeholder.enter_remarks
  ).property()


  dirty: (->
    state = @get('content.currentState.stateName')
    state == 'root.loaded.updated.uncommitted'
  ).property('content.currentState.stateName')


  focusOut: ->
    @saveRemark()
    false


  keyUp: (evt) ->
    switch evt.which
      when 27 then @clearInput()
    return true


  saveRemark: ->
    @get('content').save() if @get('dirty')
    false


  clearInput: ->
    @get('content').rollback()
})
