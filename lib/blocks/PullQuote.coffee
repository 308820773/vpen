class PullQuote extends Block
  constructor: ($base, options)->
    super($base, options)
    @_init()

  _init: ()->
    @$text.attr('contenteditable', 'true')

  _get_data: ()->
    {
      tid: @$block.attr('id')
      _type: @type
      body: @$text.text()
    }

  _init_nav: ()->
    'noting'
