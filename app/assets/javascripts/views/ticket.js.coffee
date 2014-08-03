Voice.TicketView = Ember.View.extend({

  tagName: 'tr'


  didInsertElement: ->
    # FIXME this doesn't work:
    # @$().foundation()


  willDestroyElement: ->
    # tooltip = @$('span.has-tip').attr('data-selector')
    # ($ "span.tooltip[data-selector='#{tooltip}']").remove()
})

