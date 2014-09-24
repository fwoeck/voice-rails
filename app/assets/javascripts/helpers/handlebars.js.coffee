Ember.Handlebars.registerHelper('t', (value, options) ->
  value.split('.').reduce(
    ((base, key) -> base[key]), i18n
  )
)

Ember.Handlebars.registerHelper('agentTitle', (_, options) ->
  return "" unless a = @get('model')
  "#{i18n.domain.email}: #{a.get 'email'}<br />#{i18n.domain.sip_extension}: #{a.get 'name'}"
)

Ember.Handlebars.registerHelper('bridgeTitle', (_, options) ->
  return "" unless c = @get('model')
  "#{c.get 'id'}<br />#{i18n.domain.answered_at}: #{moment(c.get 'calledAt').format()}"
)

Ember.Handlebars.registerHelper('callTitle', (_, options) ->
  return "" unless c = @get('model')
  "#{c.get 'id'}<br />#{i18n.domain.called_at}: #{moment(c.get 'calledAt').format()}"
)

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

Ember.Handlebars.helper('crmuserUser', (value, options) ->
  app.getCrmUserFrom(value) if value
)

Ember.Handlebars.helper('agentFor', (value, options) ->
  app.getAgent(value) if value
)

Ember.Handlebars.helper('printSkill', (value, options) ->
  env.skills[value]
)

Ember.Handlebars.helper('printQC', (data, val1, val2, tr, options) ->
  val = data.get("queuedCalls.#{val1}.#{val2}") || 0
  app.renderStatsEntry(val, 10, 20)
)

Ember.Handlebars.helper('printDC', (data, val1, val2, options) ->
  val = data.get("dispatchedCalls.#{val1}.#{val2}") || 0
  app.renderStatsEntry(val, 10, 20)
)

Ember.Handlebars.helper('printMD', (data, val1, val2, options) ->
  val = data.get("maxDelay.#{val1}.#{val2}") || 0
  app.renderStatsEntry(val, 10, 20)
)

Ember.Handlebars.helper('printAD', (data, val1, val2, options) ->
  val = data.get("averageDelay.#{val1}.#{val2}") || 0
  app.renderStatsEntry(val, 10, 20)
)

Ember.Handlebars.helper('printLanguageHeader', (language, languages, options) ->
  header = languages.sort().map( (lang) ->
    "<a class='#{if lang == language then 'active' else ''}' href='#'>#{lang.toUpperCase()}</a>"
  ).join(' &bull; ')

  new Ember.Handlebars.SafeString header
)
