class HR extends Block
  constructor: ($base, options)->
    super($base, options)
    @_init()

  _init: ()->
    @$text.attr('contenteditable', 'true')

  _get_data: ()->
    {
      tid: @$block.attr('id'),
      _type: 'HR',
      text: ''
    }
