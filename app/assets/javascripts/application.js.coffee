#= require jquery
#= require rails
#= require jquery.json.js
#= require jquery.websocket
#= require foundation/foundation
#= require foundation/foundation.tab
#= require common-helpers
#= require sse-connection
#= require js-phone
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require voice

window.Voice = Ember.Application.create(
  rootElement: '#ember_main'
)

if app.noLogin()
  Voice.deferReadiness()
  $(document).foundation()
  app.setupInterface()
