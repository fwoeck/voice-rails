Voice.CompCall = Ember.Mixin.create({

  compare: (x, y) ->
    return 0 if x.get('channel1') == y.get('channel1')
    return 1

})


Voice.Call = DS.Model.extend(Ember.Comparable, Voice.CompCall, {

  channel1:  DS.attr 'string'
  channel2:  DS.attr 'string'
  language:  DS.attr 'string'
  callerId:  DS.attr 'string'
  hungup:    DS.attr 'boolean'
  skill:     DS.attr 'string'

})
