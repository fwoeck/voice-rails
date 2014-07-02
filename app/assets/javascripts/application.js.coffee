#= require jquery
#= require rails
#= require jquery.json.js
#= require jquery.websocket
#= require foundation/foundation
#= require js-phone
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require voice

window.Voice = Ember.Application.create()

window.setupSSE = ->
  sseSource    = new EventSource('/events')
  messageRegex = /^(New|DTMF|PeerStatus|Originate|Masquerade|Rename|Bridge|Hangup|SoftHangup)/

  window.onbeforeunload = ->
    sseSource.close()
    console.log(new Date, 'Closed SSE connection.')


  sseSource.onopen = (event) ->
    console.log(new Date, 'Opened SSE connection.')


  sseSource.onerror = (event) ->
    console.log(new Date, 'SSE connection error', event)
    window.setTimeout window.setupSSE, 1000
    sseSource.close()


  sseSource.onmessage = (event) ->
    data = JSON.parse(event.data)

    if data.from
      console.log(new Date, 'Call from:', data.from, 'To:', data.to)
    else if messageRegex.test(data.name)
      console.log(new Date, data.name, data.headers)

jQuery ->
  setupSSE()
  $(document).foundation()
