Voice.DialogController = Ember.ObjectController.extend {

  modelBinding: 'Voice.dialogContent'

  actions:
    noop: ->
      false

    cancelDialog: ->
      @cancel()

    acceptDialog: ->
      return false if @anyErrors()
      @accept()


  init: ->
    @_super()
    Voice.dialogController = @


  unfocus: ->
    app.focusDefaultTabindex()


  isActive: ( ->
    !!@get('model.message')
  ).property('model.message')


  anyErrors: ->
    ($ '#dialog_wrapper small.error:visible').length > 0


  cancel: ->
    @clear()

    reject = @get('model.reject')
    if typeof reject == 'function'
      Ember.run @, reject


  accept: ->
    resolve = @get('model.resolve')
    if typeof resolve == 'function'
      @resolvePromise(resolve)
    else
      @clear()


  resolvePromise: (resolve) ->
    if @get('requiresInput')
      text = @get 'text'

      if @inputIsValid(text)
        @clear()
        Ember.run @, resolve, text
    else
      @clear()
      Ember.run @, resolve


  inputIsValid: (text) ->
    (text && text.length > 0) || @get('inputIsOptional')


  parsedMessage: ( ->
    @get('message')?.replace(/^(fa-.+?) /, '<i class="icon fa $1"></i>')
                    .replace(/\[(.+?)\]/,  '<i data-tooltip="" class="fa fa-info-circle has-tip radius" title="$1"></i>')
  ).property('message')
    

  clear: ->
    model = @get 'model'
    return unless model

    model.set 'message', null
    model.set 'text',    null


  requiresDecision: ( ->
    type = @get('model.type')
    type == 'question' || type == 'dialog'
  ).property('model.type')


  requiresInput: ( ->
    @get('model.type') == 'dialog'
  ).property('model.type')


  inputIsOptional: ( ->
    @get('model.format') == 'optional'
  ).property('model.format')


  validatesMessage: ( ->
    @get('model.format') == 'message'
  ).property('model.format')

}
