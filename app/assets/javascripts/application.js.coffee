#= require jquery
#= require jquery.json.js
#= require jquery.websocket
#= require phone
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require voice

window.Voice = Ember.Application.create()

window.sseSource      = new EventSource('/events')
window.onbeforeunload = -> window.sseSource.close()
messageRegex          = /^(New|DTMF|PeerStatus|Originate|Masquerade|Rename|Bridge|Hangup|SoftHangup)/

sseSource.onmessage = (event) ->
  data = JSON.parse(event.data)

  if data.from
    console.log('>> Call from:', data.from, 'To:', data.to)
  else if messageRegex.test(data.name)
    console.log(data.name, data.headers)
