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
