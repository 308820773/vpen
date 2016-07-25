class TextBlock extends Block
  constructor: ($base, options)->
    super($base, options)
    @block_type = @$block.data('block-type').toUpperCase()
    @_init()
  _init: ()->
    @_init_text()
    @_init_area_nav()
    @_init_block_nav()
    @_inactive()
    @_bind_placeholder()

  _get_data: ()->
    {
      tid: @$block.attr('id'),
      _type: @block_type,
      text: @$text.html()
    }

  _bind_placeholder: ()->
    @$text.cea_placeholder() if @_is_title(@$text)

  _init_text: ()->
    unless @$text.length
      @$block.wrapInner("<p class='pen text'></p>")
    @_init_pen()

  _init_block_nav: ()->
    @$block_nav = $("
      <div class='dropdown block_nav' contenteditable='false'>
        <a class='selected create tag' data-toggle='dropdown' aria-haspopup='true' role='button' aria-expanded='false' data-target='#'>P</a>
        <ul class='dropdown-menu tags' role='menu'>
        </ul>
      </div>
    ").appendTo(@$block)

    @$block_ul = @$block_nav.find('ul.tags')

    $this = @
    for type in $this.options.blockList
      $li = $("<li><a class='tag' href='javascript:void(0)'></a></li>")
      $li.find('a').addClass(type).text(type).attr('data-action', type)
      $li.appendTo($this.$block_ul)

    @$block_nav.appendTo($this.$block)

  _init_area_nav: ()->
    @$area_nav = $("
      <div class='dropdown area_nav' contenteditable='false'>
        <a class='selected tag' data-toggle='dropdown' aria-haspopup='true' role='button' aria-expanded='false' data-target='#'>P</a>
        <ul class='dropdown-menu tags' role='menu'>
        </ul>
      </div>
    ").appendTo(@$block)


    @$ul = @$area_nav.find('ul.tags')
    @$selected = @$area_nav.find('.selected')

    $this = @
    for type in $this.options.areaList
      $li = $("<li><a class='tag' href='javascript:void(0)'></a></li>")
      $li.find('a').addClass(type).text(type).attr('data-action', type)
      $li.appendTo($this.$ul)

      if type == $this.block_type
        $this.$selected.addClass(type).text(type)
        $li.addClass('active')

    @$area_nav.appendTo($this.$block)

  _init_pen: ()->
    if @_is_title(@$text)
      @$text.attr('contenteditable', '').addClass('pen')
    else
      @o_pen = new Pen($.extend true, { list: @options.text_list, editor: @$text[0] }, @options)

  _set_placeholder: ($text)->
    if $text.text().replace(/\s/ig, '').length
      $text.removeClass('pen-placeholder')
    else
      console.log 'addd'
      $text.addClass('pen-placeholder')

  _destroy_pen: ()->
    if @o_pen
      @o_pen.destroy()
      @$text.attr('contenteditable', '').addClass('pen')

    @_set_placeholder(@$text)

  _inactive: ()->
    super()
    @_destroy_pen()

    # destroy $area_nav
    @$area_nav.hide()
    @$block_nav.hide()

  _active: ()->
    $this = @
    super()
    @_init_nav()
    @_rebuid_pen()
    @_remove_empty_div(@$text)

#    $this.$text.focus()

    sel = window.getSelection();
    range = document.createRange();
    range.setStartBefore($this.$text[0]);
    # range.setStartAfter($this.$text[0].lastChild);
    range.collapse(true);

    sel.removeAllRanges();
    sel.addRange(range);

#    range.select();

#    document.getSelection().setSingleRange(range);

#    editor.selection.setRangeAfter(last);


#    console.log @$block.width()
#    console.log @$text.width()
#
#    if @$block.width() == @$text.width()
#      @$block.removeClass('right_float')
#    else
#      @$block.addClass('right_float')


  _active_area_nav: ()->
    @$block_nav.hide()
    @$area_nav.show()

  _active_block_nav: ()->
    @$block_nav.show()
    @$area_nav.hide()

  _rebuid_pen: ()->
    if @o_pen
      @o_pen.rebuild()

  _init_nav: ()->
    if @_is_empty(@$text)
      @_active_block_nav()
    else
      @_active_area_nav()

  _destroy: ()->
    @$block.remove()

  _update_area_nav: ()->
    @$click = @$ul.find("li a.#{@block_type}").parents('li')
    @$selected.attr('class', 'tag selected').addClass(@block_type).text(@block_type)
    @$ul.find('li').removeClass('active')
    @$click.addClass('active')

  _change_type: (new_type)->
    unless new_type == @block_type
      @block_type = new_type
      @$block.attr('data-block-type', new_type)
      @_update_area_nav()
      @_inactive()
      @_init_nav()

      @_simple_update_$text(new_type)
      @_init_pen()
      @_set_placeholder(@$text)

  _simple_update_$text: (new_type)->
    $tmp_text = @$text

    switch @block_type
      when 'UL'
        @$text = $("<ul></ul>")
      when 'OL'
        @$text = $("<ol></ol>")
      when 'H3'
        @$text = $("<h3></h3>")
      when 'H4'
        @$text = $("<h4></h4>")
      when 'H5'
        @$text = $("<h5></h5>")
      when 'CP'
        @$text = $("<p class='text_center'></p>")
      when 'RP'
        @$text = $("<p class='text_right'></p>")
      else
        @$text = $("<p></p>")

    @$text.append($tmp_text.html())
          .addClass('text')
          .addClass('pen-placeholder')
          .attr('data-placeholder', $tmp_text.attr('data-placeholder'))

    @_simple_update_text_content(@$text).replaceAll($tmp_text)

  # init not fire, only fired in area_nav clicked
  _simple_update_text_content: ($text)->
    if @_is_title($text)
      @_simple_update_title_text($text)
    else if @_is_list($text)
      @_simple_update_list_text($text)
    else
      @_simple_update_p_or_quote_text($text)

    $text

  # if li { li -> p }
  _simple_update_p_or_quote_text: ($text)->
    $lis = $text.find('li')
    if $lis.length
      $text.empty()
      $lis.each (i, li)->
        $block = $('<p></p>').html($(li).html())
        $block.appendTo($text)

  # if p { p -> li }
  _simple_update_list_text: ($text)->
    $lis = $text.find('li')
    unless $lis.length && !@_is_empty($text)
      $ps = $text.find('p')
      $_text = $text.clone()
      $text.empty()

      if $ps.length
        $ps.each (i, p)->
          $li = $('<li></li>').html($(p).html())
          $li.appendTo($text)
      else
        $li = $('<li></li>').html($_text.html())
        $li.appendTo($text)

  _simple_update_title_text: ($text)->
    @_simple_update_p_or_quote_text($text)
    $ps = $text.find('p')

    if $ps.length
      $ps.each (i, p)->
        $p = $(p)
        $_p = $p.clone()
        $p.empty().text($_p.text())
    else
      $_text = $text.clone()
      $text.empty().text($_text.text())
