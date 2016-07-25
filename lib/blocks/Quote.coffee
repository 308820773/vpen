class Quote extends Block
  constructor: ($base, options)->
    super($base, options)

    @$body = @$text.find('.text_content')
    @$source_link = @$block.find('.ll')

    @_init()

  _init: ()->
    @_init_block_edit_nav()
    @_init_del_nav()
    @$text.attr('contenteditable', 'true')

  _get_data: ()->
    {
      tid: @$block.attr('id')
      _type: @type
      body: @$body.text().replace(/\s+/ig, ' ')
      data_bg: @$block.find('blockquote').data('bg')
      web_link:
        html: @$source_link.html()
        url: @$source_link.attr('href')
        title: @$source_link.find('.link_label').text()
    }
