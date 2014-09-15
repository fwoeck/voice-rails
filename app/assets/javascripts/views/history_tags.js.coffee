Voice.HistoryTagsView = Ember.View.extend({

  allUsersBinding: 'Voice.allUsers'


  tagList: (->
    users = @get('allUsers') || []
    @extractTagsFrom(users).sort()
  ).property('allUsers.@each.{name,email}')


  extractTagsFrom: (users) ->
    users.mapProperty('email').concat(
      users.mapProperty('name').concat(
        Ember.keys(env.defaultTags)
      )
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


  addToTags: (tag) ->
    tags = @get('controller.tags')
    tags.addObject(tag) unless tags.indexOf(tag) > -1


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
