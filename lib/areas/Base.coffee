class Base extends ORange
  constructor: ($base, options)->
    @$block = $base
    @options = options
    @type = @$block.data('type')

    @$block_nav_base = $('')
    @$area_nav_base = $("
      <div class='dropdown area_nav' contenteditable='false'>
        <a class='selected tag' data-toggle='dropdown' aria-haspopup='true' role='button' aria-expanded='false' data-target='#'>P</a>
        <ul class='dropdown-menu tags' role='menu'>
        </ul>
      </div>
    ")

    @$area_nav_li_base = $("<li><a class='tag' href='javascript:void(0)'></a></li>")

    @_init()

  _init: ()->
    @_init_area()


#    @$base.addClass('pen')
#    @_init_area_nav()
#    @_init_block_nav()
#    @_destroy()

  _init_area: ()->
    console.log @$block

#    @_init_text()
#    _options = @_pen_options()
#    @o_pen = new Pen(_options)

  _init_area_nav: ()->
    @$area_nav = @$base.find('.area_nav')

    if @$area_nav.length
      @_selected_area_nav()
    else
      @_create_area_nav()

  _bind_event: ()->

  _create_area_nav: ()->

  _pen_options: ()->
    $.extend true, { editor: @$area[0] }, @options

  _init_block_nav: ()->

  _area_List: ()->
    ['P', 'H2', 'H3', 'H4', 'OL', 'UL']

  _create_area_nav: ()->
    $this = @

    $this.$area_nav = $this.$area_nav_base.clone()
    $this.$ul = $this.$area_nav.find('ul.tags')
    $this.$selected = $this.$area_nav.find('.selected')

    for type in $this._area_List()
      $li = $this.$area_nav_li_base.clone()
      $li.find('a').addClass(type).text(type)
      $li.appendTo($this.$ul)

      if type == $this.type
        $this.$selected.addClass(type).text(type)
        $li.addClass('active')

    $this.$area_nav.appendTo($this.$base)

  _selected_area_nav: ()->
    @$ul = @$area_nav.find('ul.tags')
    @$selected = @$area_nav.find('.selected')
    @$click = @$ul.find("li .#{@type}").parents('li')

    @$selected.attr('class', 'tag selected').addClass(@type).text(@type)
    @$ul.find('li').removeClass('active')
    @$click.addClass('active')

  _active: ()->
    @$base.addClass('editing')

    @o_pen.rebuild()
    # @$area_nav.show()
    # @$selected.dropdown('toggle') if @$area_nav.hasClass('open')
    @$area_nav.css('opacity', '1')

  _destroy: ()->
    @$base.removeClass('editing')

    # destroy area
    @o_pen.destroy()
    @$base.attr('contenteditable', 'true')

    # destroy $area_nav
    # @$area_nav.hide()
    @$area_nav.css('opacity', '0')

  _keyboard: (e, oSelect, oRange)->
    @oSelect = oSelect
    @oRange = oRange

    @oBefore = @_get_before_range(@$area, @oRange)
    @oAfter = @_get_after_range(@$area, @oRange)

    true

  _insert_enter: ()->
    @oRange.deleteContents()

    # @_check_br(@oBefore)

    $br = $('<br />')
    @oRange.insertNode($br[0])
    @oSelect.addRange(@oRange)
    @oSelect.collapseToEnd()
