Voice.EntryView = Ember.View.extend({

  tagName:            'tr'
  classNameBindings: ['controller.callIsCurrent']


  didInsertElement: ->
    mailbox = @get 'controller.content.mailbox'
    @setupJplayer(mailbox) if mailbox


  setupJplayer: (mailbox) ->
    player    = @get 'controller.mailboxPlayer'
    container = @get 'controller.mailboxContainer'

    ($ "##{player}").jPlayer({
      volume: 1.0
      muted: false
      supplied: 'wav'
      solution: 'html'
      errorAlerts: false
      preload: 'metadata'
      warningAlerts: false
      cssSelectorAncestor: "##{container}"
      ready: ->
        ($ @).jPlayer('setMedia', wav: "/record/#{mailbox}.wav")
    })


  willDestroyElement: ->
    if player = @get('controller.mailboxPlayer')
      ($ "##{player}").jPlayer('destroy')
})
