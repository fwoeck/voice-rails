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

Ember.Handlebars.helper('agentName', (value, options) ->
  Voice.store.getById('user', value)?.get('displayName') if value
)
