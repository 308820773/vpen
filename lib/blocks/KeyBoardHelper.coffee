class KeyBoardHelper extends Helper
  # --- TEXT EVENT - START  ------- #
  _text_key_delete: (o_block)->
    if @_is_empty(o_block.$text)
      @_destroy_block(o_block)
      false

  _text_key_up: (o_block)->
    $text = o_block.$text
    oSelect = @_get_selection()

    if oSelect
      anchor = oSelect.anchorNode
      first_node = @_get_first_text_node($text[0])

      if @_is_empty($(first_node))
        first_node = @_get_first_text_node($text.children().first()[0])

      $prev = @_get_prev_blcok(o_block.$block)

      base = oSelect.baseOffset
      if (oSelect.anchorOffset == base || oSelect.anchorOffset == 0) && first_node == anchor
        @_active_block($prev.data('block')) if $prev.length

  _text_key_down: (o_block)->
    $text = o_block.$text
    oSelect = @_get_selection()

    if oSelect
      focus = oSelect.focusNode

      last_node = @_get_last_text_node($text[0])

      if @_is_empty($(last_node))
        last_node = @_get_last_text_node($text.children().last()[0])

      $next = @_get_next_block(o_block.$block)

      base = oSelect.baseOffset

      if last_node == focus && (oSelect.focusOffset == focus.textContent.length || base == oSelect.focusOffset )
        @_active_block($next.data('block')) if $next.length

  _text_key_enter: (o_block)->
    if @_is_list(o_block.$text)
      @_enter_list(o_block)
    else
      @_enter_block(o_block)

  _enter_block: (o_block)->
    $dom = o_block.$text

    $br = @_each_dom_br($dom)
    $br_moz = $br.filter("[type='_moz']")
    p_length = $dom.find('p, div').length

    num = $br.length
    num -= 1 if @_is_empty($dom) || $br_moz.length

    if num >= 1
      $br.remove()
      $br_moz.remove()
      @_add_empty_block(o_block)

  _enter_list: (o_block)->
    $dom = o_block.$text

    $lis = $dom.find('li')

    l = $lis.length
    if l > 2
      $last = $($lis[l-1])
      $last_2 = $($lis[l-2])

      if @_is_empty($last) && @_is_empty($last_2)
        $last.remove()
        $last_2.remove()
        @_add_empty_block(o_block)
  # --- TEXT EVENT - END  ------- #

  # --- HR EVENT - START  ------- #
  _hr_key_delete: (o_block)->
    @_destroy_block(o_block)

  _hr_key_up: (o_block)->
    $prev = @_get_prev_blcok(o_block.$block)
    @_active_block($prev.data('block')) if $prev.length

  _hr_key_down: (o_block)->
    $next = @_get_next_block(o_block.$block)
    @_active_block($next.data('block')) if $next.length

  _hr_key_enter: (o_block)->
    @_add_empty_block(o_block)
    false
  # --- HR EVENT - END  ------- #

  # --- PixImage EVENT - START  ------- #
  _img_key_up: (o_block)->
    $prev = @_get_prev_blcok(o_block.$block)
    @_active_block($prev.data('block')) if $prev.length

  _img_key_down: (o_block)->
    $next = @_get_next_block(o_block.$block)
    @_active_block($next.data('block')) if $next.length

  _img_key_delete: (o_block)->
    @_destroy_block(o_block)

  _img_key_enter: (o_block)->
    @_add_empty_block(o_block)
    false
  # --- PixImage EVENT - END  ------- #

  # --- Quote EVENT - START  ------- #
  _quote_key_delete: (o_block)->
    @_destroy_block(o_block)
    false

  _quote_key_up: (o_block)->
    $prev = @_get_prev_blcok(o_block.$block)
    @_active_block($prev.data('block')) if $prev.length

  _quote_key_down: (o_block)->
    $next = @_get_next_block(o_block.$block)
    @_active_block($next.data('block')) if $next.length

  _quote_key_enter: (o_block)->
    @_add_empty_block(o_block)
    false
  # --- Quote EVENT - END  ------- #

  # keyCode
  _code_is_word: (code)->
    true if code >= 65 && code <= 90 # A-Z

  _code_is_number: (code)->
    true if code >= 48 && code <= 57 # 0-9
    true if code >= 96 && code <= 105 # 数字键盘 0-9

  _code_is_fn: (code)->
    true if code >= 112 && code <= 123 # f11 - f12

  _code_is_del: (code)->
    true if code == 8 || code == 46 # <- delete

  _code_is_direction: (code)->
    true if code >= 37 && code <= 40 # 上下左右

  _code_is_enter: (code)->
    true if code == 13

  _code_is_blank: ()->

  _code_is_punctuation: ()->
    # 标点
  _code_is_operator: ()->
    # + - * /

  _enable_input: ($text)->
    $this = @

    $text.keydown (e)->
      unless $this._code_is_direction(e.keyCode) || $this._code_is_fn(e.keyCode)
        false

  # block
  _get_near_block: ($block)->
    $prev = @_get_prev_blcok($block)
    $next = @_get_next_block($block)

    $prev.add($next).first()

  _get_prev_blcok: ($block)->
    $block.prevAll(@options.editorSelect).first()

  _get_next_block: ($block)->
    $block.nextAll(@options.editorSelect).first()



