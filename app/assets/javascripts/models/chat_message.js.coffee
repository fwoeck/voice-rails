Voice.ChatMessage = DS.Model.extend(Voice.Resetable, {

  to:         DS.attr 'string'
  from:       DS.attr 'string'
  content:    DS.attr 'string'
  createdAt:  DS.attr 'date'


  fromName: (->
    from = @get('from')
    user = @store.all('user').find (u) -> u.get('email') == from
    if user then user.get('displayName') else from
  ).property('from')
})


Voice.ChatMessage.reopenClass({

  send: (text, to=null) ->
    cm = Voice.store.createRecord('chatMessage', {
      content:   text,
      createdAt: new Date,
      from:      Voice.get('currentUser.email'),
      to:        to
    })
    cm.save()
})
