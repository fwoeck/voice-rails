Ember.ChatInput = Ember.TextField.extend({

  name:      'chat_message'
  maxlength: '150'


  placeholder: (->
    i18n.placeholder.type_here
  ).property()


  keyUp: (evt) ->
    switch evt.which
      when 13 then @sendMessage()
      when 27 then @clearInput()
    return true


  sendMessage: ->
    message = @get('value')
    if message
      Voice.ChatMessage.send(message)
      @set('value', '')


  clearInput: ->
    @set('value', '')
})
