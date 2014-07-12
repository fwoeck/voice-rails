Voice.ApplicationStore      = DS.Store.extend()
Voice.ApplicationAdapter    = DS.ActiveModelAdapter.extend()
Voice.ApplicationSerializer = DS.ActiveModelSerializer.extend()

Voice.aS = Voice.ApplicationSerializer.create(container: Voice.__container__)
