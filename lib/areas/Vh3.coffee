class H3 extends Base
  constructor: ($base, options)->
    super($base, options)

  _init_text: ()->
    unless @$area[0].tagName == @_type()
      $new_area = $("<h3 class='v-area pen'></h3>").text(@$area.text())
      @$area.after($new_area).remove()
      @$area = $new_area

  _type: ()->
    'H3'
