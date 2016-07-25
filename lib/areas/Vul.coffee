class UL extends Base
  constructor: ($base, options)->
    super($base, options)

  _init_text: ()->
    unless @$area[0].tagName == @_type()
      $new_area = $("<ul class='v-area pen'><li></li></ul>")
      $new_area.find('li').text(@$area.text())
      @$area.after($new_area).remove()
      @$area = $new_area

  _type: ()->
    'UL'
