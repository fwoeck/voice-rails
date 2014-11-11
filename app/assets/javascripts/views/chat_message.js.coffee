Voice.ChatMessageView = Ember.View.extend({

  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', @, @slideInMessage
    app.resetScrollPanes()


  slideInMessage: ->
    height = @$('.message').height() + 12
    tcTop  = 124 # ! This must match the css #team_chat top rule

    @$('.message').removeClass('newest')
    ($ '#team_chat').css(transition: 'initial').css(top: "#{tcTop - height}px")
    Ember.run.next @, ->
      ($ '#team_chat').css(transition: 'top ease 300ms').css(top: "#{tcTop}px")
})
