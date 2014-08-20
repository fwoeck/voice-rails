Voice.EmberGaugeComponent = Ember.Component.extend(

  didInsertElement: ->
    @send 'buildGauge'


  dataDidChange: (->
    @get('gauge').refresh @get('value')
  ).observes('value')


  actions:
    buildGauge: ->
      g = new JustGage(
        id:     @get('gid')
        min:    @get('min')   || 0
        max:    @get('max')   || 100
        value:  @get('value') || 0
        title:  @get('title')
        label:  @get('label')
        levelColors: [
          "#a9d70b", "#a9d70b", "#a9d70b", "#a9d70b", "#a9d70b",
          "#f9c802", "#f9c802",
          "#ff0000"
        ]
      )
      @set 'gauge', g
)
