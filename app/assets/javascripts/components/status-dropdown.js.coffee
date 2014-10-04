Voice.StatusDropdownComponent = Ember.Component.extend(

  defaultTags: Voice.HistoryEntry.defaultTags


  dropdownId: (->
    "dropdown-#{@get 'entry.id'}"
  ).property('entry')


  actions:
    markAs: (tag) ->
      @get('entry').addToTags(tag)
      false
)
