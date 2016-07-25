class P extends Base
  constructor: ($base, options)->
    super($base, options)

  _init_text: ()->
    unless @$area[0].tagName == @_type()
      $new_area = $("<p class='v-area pen'></p>").text(@$area.text())
      @$area.after($new_area).remove()
      @$area = $new_area

  _type: ()->
    'P'

  _keyboard: (e, oSelect, oRange)->
    super(e, oSelect, oRange)

    @_continue = true
    # 从页面删除选中内容
    # oSelect.deleteFromDocument()
#    @_insert_enter()

#    # 锚点 鼠标按下瞬间的那个点
#    console.log oSelect.anchorNode
#    console.log oSelect.anchorOffset
#
#    # 焦点 选区的终点
#    console.log oSelect.focusNode
#    console.log oSelect.focusOffset
#
#    # 范围 range
#    console.log oSelect.rangeCount
#
#    # 判断是否为空节点
#    console.log oSelect.isCollapsed
#
#    # 移动光标
#    console.log oSelect.collapseToStart()
#    console.log oSelect.collapseToEnd()
#
#    # 将 range 从选取中移除(取消选择)
#    console.log oSelect.removeRange(oRange)
#
#    oRange1 = document.createRange()
#    oRange1.selectNode(@$area.find('b')[0])
#
#    # 因为只能有一个 range 所以 == 切换 range 选区
#    console.log oSelect.addRange(oRange1)


    # 回车
    if e.keyCode == 13
      @_insert_enter()
      @_continue = false

    @oBefore.detach()
    @oAfter.detach()

    @_continue
