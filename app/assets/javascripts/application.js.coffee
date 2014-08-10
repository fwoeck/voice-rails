#= require jquery
#= require rails
#= require fastclick
#= require jquery.json.js
#= require jquery.jplayer
#= require jquery.websocket
#= require foundation/foundation
#= require foundation/foundation.tab
#= require foundation/foundation.tooltip
#= require gravatar
#= require moment
#= require common
#= require connections
#= require js-phone
#= require handlebars
#= require ember
#= require ember-data
#= require ember-shortcuts
#= require_self
#= require voice

app.compileSkillPartials()
app.compileLanguagePartials()
app.compileAvailabilityPartials()

window.Voice = Ember.Application.create(
  rootElement: '#ember_main'
)

if app.noLogin()
  Voice.deferReadiness()
  app.initFoundation()
  app.setupInterface()
