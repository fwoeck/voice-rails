#= require jquery
#= require rails
#= require jquery.json.js
#= require jquery.websocket
#= require foundation/foundation
#= require foundation/foundation.tab
#= require sse-connection
#= require common
#= require js-phone
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require voice

window.Voice = Ember.Application.create()
if env.userId.length == 0
  Voice.deferReadiness()

jQuery ->
  $(document).foundation()
  setupInterface()
  setupSSE()
