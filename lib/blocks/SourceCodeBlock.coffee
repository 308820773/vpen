class SourceCodeBlock extends Block
  constructor: ($base, options)->
    super($base, options)

    @$code = @$block.find('code')
    # @source = @$code.data('source')

    @_init()

  _init: ()->
    @_init_block_edit_nav()
    @_init_del_nav()
    @$text.attr('contenteditable', 'true')

  _get_data: ()->
    {
      tid: @$block.attr('id')
      _type: @type,
      body: @$code.text(),
      highlight_style: @$block.data('style')
      language: @$code.data('language'),
    }

