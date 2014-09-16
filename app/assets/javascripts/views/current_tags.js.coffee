Voice.CurrentTagsView = Ember.View.extend({

  allUsersBinding: 'Voice.allUsers'
  defaultTags:      Voice.HistoryEntry.defaultTags


  actions:
    removeTag: (tag) ->
      @removeFromTags(tag)
      false


  tagList: (->
    users = @get('allUsers') || []
    @extractTagsFrom(users).sort()
  ).property('allUsers.@each.{name,email}')


  extractTagsFrom: (users) ->
    users.mapProperty('email').concat(
      users.mapProperty('name').map((n) -> "##{n}").concat @defaultTags
    )


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
      @addToTags(tag)
      return true
    else
      return false


  removeDefaultTags: (tag) ->
    tags = @get('controller.content.tags')
    if @defaultTags.indexOf(tag) > -1
      @defaultTags.forEach (dt) -> tags.removeObject(dt)


  removeFromTags: (tag) ->
    entry = @get('controller.content')
    tags  = entry.get('tags')

    tags.removeObject(tag)
    entry.save()


  addToTags: (tag) ->
    entry = @get('controller.content')
    tags  = entry.get('tags')

    unless tags.indexOf(tag) > -1
      @removeDefaultTags(tag)
      tags.addObject(tag)
      entry.save()


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
