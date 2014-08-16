Voice.StatsView = Ember.View.extend({

  dataBinding:  'controller.content.firstObject'
  currentLang:   null


  staticLang: (->
    'en' # TODO Make this selectable
  ).property()


  didInsertElement: ->
    self = @
    data = @get('data')

    @setDisplayProperties()
    @refreshTimer = window.setInterval (->
      Voice.store.find('dataset').then ->
        data.triggerStatsUpdate()
        self.cycleLangs()
    ), 3000


  setDisplayProperties: ->
    @$(".language_details.#{@get 'staticLang'}").addClass('first')
    @cycleLangs()


  cycleLangs: ->
    sl    = @get 'staticLang'
    cl    = @get 'currentLang'
    langs = Ember.keys(env.languages).removeObject(sl)
    index = (langs.indexOf(cl) + 1) % langs.length
    lang  = langs[index]

    @set 'currentLang', lang
    @$('.language_details').removeClass('second')
    @$(".language_details.#{lang}").addClass('second')


  willDestroyElement: ->
    window.clearInterval @refreshTimer
})
