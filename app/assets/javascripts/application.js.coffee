#= require jquery
#= require rails
#= require fastclick
#= require jquery.json.js
#= require jquery.jplayer
#= require jquery.websocket
#= require foundation/foundation
#= require foundation/foundation.tab
#= require foundation/foundation.abide
#= require foundation/foundation.tooltip
#= require typeahead.bundle
#= require gravatar
#= require raphael
#= require justgage
#= require moment
#= require moment.de
#= require common
#= require connections
#= require js-phone
#= require handlebars
#= require ember
#= require ember-data
#= require ember-shortcuts
#= require_self
#= require voice

"use strict"

# FIXME This prevents vertical scrolling for iOS webapps, but
#       makes scrollareas unusable:
#
# ($ document).bind('touchmove', false)

app.compileSkillPartials()
app.compileLanguagePartials()
app.compileAvailabilityPartials()

app.aggregateSkillSelection()
app.aggregateLanguageSelection()
app.aggregateRoleSelection()

app.setupMoment()
app.setupAbide()

window.Voice = Ember.Application.create(
  rootElement: '#ember_main'
)

if app.noLogin()
  Voice.deferReadiness()
  app.initFoundation()
