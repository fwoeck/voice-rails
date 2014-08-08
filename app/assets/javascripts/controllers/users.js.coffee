Voice.UsersController = Ember.ArrayController.extend({

  availableAgents: (->
    @get('content').filter( (a) ->
      a.get('availability') == 'ready' && a.get('isCallable')
    ).length
  ).property('content.@each.{isCallable,availability}')
})
