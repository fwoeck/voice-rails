Ember.Handlebars.helper('upcase', (value, options) ->
  value.toUpperCase() if value
)

Ember.Handlebars.helper('downcase', (value, options) ->
  value.toLowercase() if value
)

Ember.Handlebars.helper('capitalize', (value, options) ->
  value.capitalize() if value
)
