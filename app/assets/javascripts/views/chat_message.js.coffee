Voice.ChatMessageView = Ember.View.extend({

  didInsertElement: ->
    height = @$('.message').height() + 16 # 16 == 2 * 8px padding
    tcTop  = 125 # ! This must match the css #team_chat top rule

    ($ '#team_chat').css(transition: 'initial')
                    .css(top: "#{tcTop - height}px")

    Ember.run.next @, ->
      ($ '#team_chat').css(transition: 'top ease 300ms')
                      .css(top: "#{tcTop}px")
      @$('.message').removeClass('newest')
})
