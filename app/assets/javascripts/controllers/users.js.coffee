Voice.UsersController = Ember.ArrayController.extend({

  availableAgents: (->
    @get('allAgents').filter( (a) ->
      a.get('availability') == 'ready' && a.get('isCallable')
    ).length
  ).property('allAgents.@each.{isCallable,availability}')


  allAgents: Ember.computed.filterProperty 'content', 'isNew', false
})
