Voice.StatsView = Ember.View.extend({

  dataBinding:      'controller.content.firstObject'
  rrdSourceBinding: 'controller.rrdSource'
  currentLang:       null


  didInsertElement: ->
    self = @
    data = @get('data')

    @setDisplayProperties()

    @refreshTimer = window.setInterval (->
      Voice.store.find('dataset').then ->
        data.triggerStatsUpdate()
        self.cycleLangs()
    ), 3000

    @rrdTimer = window.setInterval (->
      self.set 'rrdSource', "/images/queue-stats.png?#{new Date().getTime()}"
    ), 60000


  setDisplayProperties: ->
    @cycleLangs()


  cycleLangs: ->
    lang  = @get 'currentLang'
    langs = Ember.keys(env.languages)
    index = (langs.indexOf(lang) + 1) % langs.length
    lang  = langs[index]

    @set 'currentLang', lang
    @$('.language_details').removeClass('active')
    @$(".language_details.#{lang}").addClass('active')


  willDestroyElement: ->
    window.clearInterval @refreshTimer
    window.clearInterval @rrdTimer
})
