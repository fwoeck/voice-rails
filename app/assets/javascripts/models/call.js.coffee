Voice.Call = DS.Model.extend({

  channel1:  DS.attr 'string'
  channel2:  DS.attr 'string'
  language:  DS.attr 'string'
  callerId:  DS.attr 'string'
  hungup:    DS.attr 'boolean'
  skill:     DS.attr 'string'

})
