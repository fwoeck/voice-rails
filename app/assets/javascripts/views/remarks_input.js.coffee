Ember.RemarksInput = Ember.TextArea.extend({

  classNameBindings: ['dirty']
  maxlength:          '1000'


  placeholder: (->
    i18n.placeholder.enter_remarks
  ).property()


  dirty: (->
    @get('entry.isDirty')
  ).property('entry.isDirty')


  focusIn: ->
    @oldValue = @get 'value'


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
    remarks = @get 'value'
    return false if remarks == @oldValue
    @get('entry').save()
    false


  clearInput: ->
    @set('value', @oldValue)
})
