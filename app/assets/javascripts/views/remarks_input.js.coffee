Ember.RemarksInput = Ember.TextArea.extend({

  classNameBindings: ['dirty']
  maxlength:          '1000'


  placeholder: (->
    i18n.placeholder.enter_remarks
  ).property()


  dirty: (->
    @get('entry.isDirty')
  ).property('entry.isDirty')


  focusOut: ->
    @saveRemark()
    false


  keyUp: (evt) ->
    switch evt.which
      # when 13 then @leaveField()
      when 27 then @clearInput()
    return true


  leaveField: ->
    @$().blur()


  saveRemark: ->
    @get('entry').save() if @get('dirty')
    false


  clearInput: ->
    @get('entry').rollback()
})
