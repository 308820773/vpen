class PixImage extends Block
  constructor: ($base, options)->
    super($base, options)
    @$img = @$block.find('img')
    @style = @$block.data('style')
    @$description = @$block.find('.description')
    @src = @$img.parent().data('src')

    @_init()

  _init: ()->
    @_init_pen_nav()
    @_init_block_edit_nav()
    @_init_del_nav()

  _get_data: ()->
    {
      tid: @$block.attr('id')
      img_sid: @$text.attr('id')
      _type: 'PixImage'
      style: @style
      url: @src
      description: @$description.text()
    }

  _active_pen_nav: ()->
    @$pen_nav.find('i').removeClass('active')
    @$pen_nav.find('i[data-action=' + @style + ']').addClass('active')

  _init_pen_nav: ()->
    unless @owner_id
      @$pen_nav = $('<div class="image_menu pen-menu pen-menu pen-nav">
        <i class="pen-icon icon-left" data-action="left"></i>
        <i class="pen-icon icon-center" data-action="center"></i>
        <i class="pen-icon icon-full" data-action="full"></i>
      </div>')

      @$pen_nav.prependTo(@$block)
      @_active_pen_nav()

    @$text.attr('contenteditable', 'true')
    # @o_pen = new Pen($.extend true, { list: @options.image_list, editor: @$img_text[0] }, @options)
    document.execCommand("enableObjectResizing", false, false);

  _destroy_pen: ()->
    if @o_pen
      @o_pen.destroy()

  _change_type: (type)->
    @style = type
    @$block.attr('data-style', type)
    @_active_pen_nav()

    obj = $('body').data('lazing')
    obj._init_style() if obj

