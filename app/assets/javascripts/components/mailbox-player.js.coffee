Voice.MailboxPlayerComponent = Ember.Component.extend(

  playerReady: false


  mouseEnter: ->
    unless @get 'playerReady'
      @set 'playerReady', true
      Ember.run.next @, @setupJplayer


  setupJplayer: ->
    mailbox   = @get 'mailbox'
    player    = @get 'mailboxPlayer'
    container = @get 'mailboxContainer'

    ($ "##{player}").jPlayer({
      volume: 1.0
      muted: false
      supplied: 'mp3'
      solution: 'html'
      errorAlerts: false
      preload: 'metadata'
      warningAlerts: false
      cssSelectorAncestor: "##{container}"
      ready: ->
        ($ @).jPlayer('setMedia', mp3: "/record/#{mailbox}.mp3")
    })


  willDestroyElement: ->
    if player = @get('mailboxPlayer')
      ($ "##{player}").jPlayer('destroy')


  mailboxPlayer: (->
    "player-#{@get 'mailbox'}"
  ).property('mailbox')


  mailboxContainer: (->
    "container-#{@get 'mailbox'}"
  ).property('mailbox')
)
