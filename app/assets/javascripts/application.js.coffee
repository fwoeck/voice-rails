#= require jquery
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require voice

window.Voice = Ember.Application.create()

window.sseSource      = new EventSource('/events')
window.onbeforeunload = -> window.sseSource.close()
sseSource.onmessage   = (event) -> console.log(JSON.parse event.data)
