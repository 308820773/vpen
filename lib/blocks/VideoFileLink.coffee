class VideoFileLink extends Block
  constructor: ($base, options)->
    super($base, options)
    @block_type = @$block.data('block-type')

    @$title = @$block.find('.title')
    @$lazing_vido = @$text.children()
    @$video = @$block.find('video')

    @_init()

  _init: ()->
    @_init_block_edit_nav()
    @_init_del_nav()
#    @$text.attr('contenteditable', 'true')
#    @$video[0].contentEditable = false

  _get_data: ()->
    {
      tid: @$block.attr('id')
      _type: @type,
      html: @$lazing_vido.data('html')
      title: @$title.text()
    }

