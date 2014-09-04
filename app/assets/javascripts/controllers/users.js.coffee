Voice.UsersController = Ember.ArrayController.extend({

  currentForm: null


  availableAgents: (->
    @get('allAgents').filter( (a) ->
      a.get('availability') == 'ready' && a.get('isCallable')
    ).length
  ).property('allAgents.@each.{isCallable,availability}')


  # Caution: The computed.filterProperty solution leads to redrawing
  #          of the agent-list whenever an agent changes _any_ state
  #          (e.g. the online visibility):
  #
  # allAgents: Ember.computed.filterProperty 'content', 'isNew', false

  allAgents: (->
    @get('content').filter (a) -> !a.get('isNew')
  ).property('content.@each.isNew')


  cuIsAdmin: (->
    /admin/.test(Voice.get 'currentUser.roles')
  ).property('Voice.currentUser.roles')
})
