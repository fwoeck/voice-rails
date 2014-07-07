#= require jquery
#= require rails
#= require jquery.json.js
#= require jquery.websocket
#= require foundation/foundation
#= require foundation/foundation.tab
#= require sse_connection
#= require js-phone
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require voice

window.Voice = Ember.Application.create()

jQuery ->
  setupSSE()
  $(document).foundation()

  ($ '#agent_overview > h5').click ->
    ($ '#call_queue').toggleClass('expanded')

  ($ '#my_settings > h5').click ->
    ($ '#my_settings').toggleClass('expanded')
    ($ '#call_queue').toggleClass('lifted')

  ($ '#call_queue > h5').click ->
    ($ '#my_settings').removeClass('expanded')
    ($ '#call_queue').addClass('expanded')
    ($ '#call_queue').addClass('lifted')
