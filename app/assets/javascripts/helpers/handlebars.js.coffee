Ember.Handlebars.helper('upcase', (value, options) ->
  value.toUpperCase() if value
)

Ember.Handlebars.helper('downcase', (value, options) ->
  value.toLowercase() if value
)

Ember.Handlebars.helper('capitalize', (value, options) ->
  value.capitalize() if value
)

Ember.Handlebars.helper('moment', (value, options) ->
  moment(value).format() if value
)

Ember.Handlebars.helper('fromNow', (value, options) ->
  moment(value).fromNow() if value
)

Ember.Handlebars.helper('zendeskUser', (value, options) ->
  app.getZendeskUserFrom(value) if value
)

Ember.Handlebars.helper('agentFor', (value, options) ->
  app.getAgentFrom(value) if value
)

Ember.Handlebars.helper('printSkill', (value, options) ->
  env.skills[value]
)

Ember.Handlebars.helper('printQC', (data, val1, val2, tr, options) ->
  val = data.get("queuedCalls.#{val1}.#{val2}") || 0
  new Ember.Handlebars.SafeString(if val then val else '&mdash;')
)

Ember.Handlebars.helper('printDC', (data, val1, val2, options) ->
  val = data.get("dispatchedCalls.#{val1}.#{val2}") || 0
  new Ember.Handlebars.SafeString(if val then val else '&mdash;')
)

Ember.Handlebars.helper('printMD', (data, val1, val2, options) ->
  val = data.get("maxDelay.#{val1}.#{val2}") || 0
  new Ember.Handlebars.SafeString(if val then val else '&mdash;')
)

Ember.Handlebars.helper('printAD', (data, val1, val2, options) ->
  val = data.get("averageDelay.#{val1}.#{val2}") || 0
  new Ember.Handlebars.SafeString(if val then val else '&mdash;')
)
