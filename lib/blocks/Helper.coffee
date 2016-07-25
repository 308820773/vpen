class Helper
  _is_title: ($dom)->
    dom = $dom[0]
    dom.tagName == 'H1' || dom.tagName == 'H2'|| dom.tagName == 'H3'||
      dom.tagName == 'H4'||  dom.tagName == 'H5'|| dom.tagName == 'H6'

  _is_list: ($dom)->
    dom = $dom[0]
    dom.tagName == 'OL' || dom.tagName == 'UL'

  _enter_img: ($dom)->
    @_add_new_block($dom)

  _enter_hr: ($dom)->
    @_add_new_block($dom)

  _enter_quote: ($dom)->
    @_add_new_block($dom)

  _remove_last_li: ($lis)->
    while @_is_empty($lis.last())
      $last = $lis.last()
      $lis = $lis.not($last)
      break unless $lis[0]

  _each_dom_br: ($dom)->
    $this = @
    $br = $('')
    dom = $dom[0]

    if dom.nodeType == 1
      if dom.hasChildNodes()
        l = dom.childNodes.length - 1

        while(l >= 0)
          node = dom.childNodes[l]
          l = l-1

          $node = $(node)

          $br = $br.add($this._each_dom_br($node))
          break unless $this._is_empty($node)

      else if dom.tagName == 'BR'
        $br = $br.add($dom)

    $br

  _get_first_text_node: (dom)->
    if dom.nodeType == 3 || @_is_empty($(dom))
      node = dom
    else
      node = @_get_first_text_node(dom.childNodes[0])

    node

  _get_last_text_node: (dom)->
    if dom.nodeType == 3 || @_is_empty($(dom))
      node = dom
    else
      node = @_get_last_text_node(dom.childNodes[dom.childNodes.length-1])

    node

  _is_empty: ($dom)->
    !($dom.text().replace(/\s/ig, '').length)

  _remove_empty_div: ($text)->
    $div = $text.find('div')
    $div.each (i, div)->
      unless div.hasChildNodes()
        $(div).remove()

  _menu_check: ()->
    $menus = $('.pen-menu')
    show = false

    $menus.each (i, menu)->
      $menu = $(menu)
      show = true if $menu.css('display') == 'block'

    show

  _nav_check: (o_block)->
    o_block.$area_nav.hasClass('open') || o_block.$block_nav.hasClass('open')

  _get_selection: ()->
    oSelect = window.getSelection()
    if oSelect.rangeCount <= 1
      oSelect
    else
      console.log 'range count is many, please reselect'
      false

  _create_tid_str: ()->
    lor = ''

    while lor.length < 6
      lor += [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f'][Math.floor(Math.random() * 16)]

    lor

  _create_tid: ()->
    str = ''

    while !@_valid_tid(str)
      str = @_create_tid_str()

    str

  _valid_tid: (tid)->
    tid.length == 6 && @_get_tid_index(tid) < 0

  _get_tid_index: (tid)->
    $.inArray(tid, @tid_arr)
