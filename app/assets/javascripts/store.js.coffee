Voice.ApplicationStore      = DS.Store.extend()
Voice.ApplicationAdapter    = DS.ActiveModelAdapter.extend()
Voice.ApplicationSerializer = DS.ActiveModelSerializer.extend()

Voice.aS = Voice.ApplicationSerializer.create(container: Voice.__container__)


DS.ArrayTransform = DS.Transform.extend(

  deserialize: (serialized) ->
    (if (Ember.typeOf(serialized) is 'array') then serialized else [])

  serialize: (deserialized) ->
    type = Ember.typeOf(deserialized)
    if type is 'array'
      deserialized
    else if type is 'string'
      deserialized.split(',').map (item) -> jQuery.trim item
    else
      []
)

Voice.register 'transform:array', DS.ArrayTransform
