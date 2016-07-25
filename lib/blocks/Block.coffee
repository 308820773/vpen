class Block extends KeyBoardHelper
  constructor: ($base, options)->
    @$block = $base.addClass('pen')
    @options = options
    @label = @$block.data('label')
    @$text = @$block.find('> .text').addClass('pen')
    @tid = @$block.attr('id')
    @owner_id = @$block.data('owner')
    @type = $base.data('type')

  _inactive: ()->
    @$block.removeClass('editing')

  _active: ()->
    @$block.addClass('editing')

  _destroy: ()->
  _get_data: ()->
    {}

  _init_block_edit_nav: ()->
    @$block_edit_nav = $("<div class='block_edit'></div>")
    @$block_edit_nav.prependTo(@$block) unless @owner_id

  _init_del_nav: ()->
    @$block_del_nav = $("<div class='block_del'></div>")
    @$block_del_nav.prependTo(@$block)
#
#  _each_node: (node)->
#    $this = @
#
#    i = node.childNodes.length
#    last_br = false
#
#    while i > 0
#      i -= 1
#
#      n = node.childNodes[i]
#      if n.nodeName == 'BR'
#        $this._create_area(n) if last_br && last_br - 1 == i
#        last_br = i
#      else if n.hasChildNodes()
#        $this._each_node(n)
#
#  _create_area: (startNode)->
#    @_create_new_block_at_start(@_area_, startNode)
#
#
#  _create_area_for_range: (_range)->
#    new_area = $('<p></p>')[0]
#    new_area.appendChild _range.extractContents()
#    new_area
#
#  _check_br: (o_editor)->
#    area = o_editor.$area[0]
#
#    @_area_ = area
#    @_each_node(area)
#    @_area_ = false
#
#  _create_new_block_at_start: (parent, startNode)->
#    sc = startNode
#    so = 0
#    ec = parent.lastChild
#    eo = parent.lastChild.length
#
#    _range = @_create_range(sc, so, ec, eo)
#    newNode = @_create_area_for_range(_range)
#
#    $(parent).parents('.editor').after $(newNode)
#    @_init_area($(newNode))
#
#  _create_new_block_at_last: (area, last_item)->
#    sc = area.childNodes[last_item]
#    so = 0
#    ec = area.lastChild
#    eo = area.lastChild.length
#
#    _range = @_create_range(sc, so, ec, eo)
#    new_area = @_create_area_for_range(_range)
#    $(area).parents('.editor').after $(new_area)
#
#  _menu_check: ()->
#    $menus = $('.pen-menu')
#    show = false
#
#    $menus.each (i, menu)->
#      $menu = $(menu)
#      show = true if $menu.css('display') == 'block'
#
#    show
