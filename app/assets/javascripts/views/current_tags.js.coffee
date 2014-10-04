Voice.CurrentTagsView = Ember.View.extend({

  allUsersBinding: 'Voice.allUsers'
  defaultTags:      Voice.HistoryEntry.defaultTags


  actions:
    removeTag: (tag) ->
      @get('controller.content').removeFromTags(tag)
      false


  # TODO Move the following two to a more prominent place:
  #
  tagList: (->
    users = @get('allUsers') || []
    @extractTagsFrom(users).sort()
  ).property('allUsers.@each.{name,email}')


  extractTagsFrom: (users) ->
    users.mapProperty('email').concat(
      Ember.keys(env.languages).map (n) -> n.toUpperCase()
    ).concat(
      Ember.keys(env.skills).map (n) -> n.replace('_', '-')
    ).concat(
      users.mapProperty('name').map (n) -> "##{n}"
    ).concat @defaultTags


  getTags: ->
    new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      local: $.map(@get('tagList'), (tag) -> value: tag)
      limit: 5
    )


  commitInput: (tag) ->
    if @get('tagList').indexOf(tag) > -1
      @$('.typeahead').typeahead('close')
      @get('controller.content').addToTags(tag)
      return true
    else
      return false


  clearInput: ->
    @$('.typeahead').typeahead('val', '')


  didInsertElement: ->
    @initializeTypeahead @getTags()


  willDestroyElement: ->
    @cleanupCallBacks()


  cleanupCallBacks: ->
    @$('.typeahead').typeahead('destroy').off()


  initializeTypeahead: (tags) ->
    tags.initialize()

    @$('.typeahead').typeahead({
      hint:      true
      highlight: true
      minLength: 1
    }, {
      name:       'tags'
      displayKey: 'value'
      source:      tags.ttAdapter()
    })
})
