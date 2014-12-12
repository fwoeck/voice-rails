Voice.ApplicationStore   = DS.Store.extend()
Voice.ApplicationAdapter = DS.ActiveModelAdapter.extend(
  namespace: env.apiVersion

  ajaxError: (jqXHR) ->
    Ember.run =>
      error = @_super(jqXHR)
      msg   = app.parseAjaxError(error) || error.statusText
      app.showDefaultError i18n.errors.ajax_error.replace('MSG', msg + '.')
)


Voice.ApplicationSerializer = DS.ActiveModelSerializer.extend()
Voice.aS = Voice.ApplicationSerializer.create(container: Voice.__container__)


Voice.ObjectTransform = DS.Transform.extend(
  deserialize: (value) ->
    unless $.isPlainObject(value)
      new Ember.Object()
    else
      value

  serialize: (value) ->
    unless $.isPlainObject(value)
      new Ember.Object()
    else
      value
)

Voice.ArrayTransform = DS.Transform.extend(
  deserialize: (value) ->
    if Ember.isArray(value)
      Em.A value
    else
      Em.A()

  serialize: (value) ->
    if Ember.isArray(value)
      Em.A value
    else
      Em.A()
)

Voice.register 'transform:array',  Voice.ArrayTransform
Voice.register 'transform:object', Voice.ObjectTransform
