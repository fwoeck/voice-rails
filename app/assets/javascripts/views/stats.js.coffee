Voice.StatsView = Ember.View.extend({

  dataBinding:        'controller.content.firstObject'
  rrdSourceBinding:   'controller.rrdSource'
  statsPausedBinding: 'controller.statsPaused'
  statsLangBinding:   'Voice.statsLang'


  didInsertElement: ->
    @setDisplayProperties()
    @setRefreshTimer()
    @setRrdTimer()


  actions:
    stepLang: ->
      @cycleLangs()
      @refreshLangs()
      false


  setRefreshTimer: ->
    self = @
    data = @get('data')

    @refreshTimer = window.setInterval (->
      Voice.store.find('dataset').then ->
        return unless self.get('_state') == 'inDOM'

        data.triggerStatsUpdate()
        unless self.get('statsPaused')
          self.cycleLangs()
          self.refreshLangs()
    ), 3000


  setRrdTimer: ->
    self = @
    @rrdTimer = window.setInterval (->
      self.updateRrdSource()
    ), 60000


  setDisplayProperties: ->
    Ember.run.next @, @updateRrdSource
    @cycleLangs() unless @get('statsLang')
    @refreshLangs()


  updateRrdSource: ->
    return if @isDestroyed
    @set 'rrdSource', "#{env.rrdSource}?#{new Date().getTime()}"


  cycleLangs: ->
    lang  = @get 'statsLang'
    langs = Ember.keys(env.languages).sort()
    index = (langs.indexOf(lang) + 1) % langs.length
    lang  = langs[index]
    @set 'statsLang', lang


  refreshLangs: ->
    lang = @get 'statsLang'
    @$('.language_details')?.removeClass('active')
    @$(".language_details.#{lang}")?.addClass('active')


  willDestroyElement: ->
    window.clearInterval @refreshTimer
    window.clearInterval @rrdTimer
})
