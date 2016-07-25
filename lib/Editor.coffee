class Editor extends KeyBoardHelper
  # 初始化 设定@xxx 元素
  constructor: ($base, options)->
    @options = options
    @$base = $base.addClass('v-editor')
    @tid_arr = []
    @$counts = $('.article_counts')
    @$submit_button = $(options.submit_button)

    @_init()
    @_init_status()
    @_init_modals()
    @_count_text()

  # init the editor
  _init: ()->
    $this = @

    @$blocks = @$base.find(@options.editorSelect)

    # 若 content 为空, 则添加一个空的 block 元素
    unless @$blocks.length
      $empty_ele = $("<div class='block' data-type='TextBlock' data-block-type='P'><p class='text'></p></div>")
      $empty_ele.appendTo @$base
      @$blocks = @$blocks.add $empty_ele

    # 创建 block 对象
    @$blocks.each (i, block)->
      $this._init_ele_block($(block))

    @$submit_button.click ()->
      body_json = []

      $this.$blocks = $this.$base.find($this.options.editorSelect)
      $this.$blocks.each (i, block)->
        body_json[i] = $(block).data('block')._get_data()

      console.log body_json

      $.ajax
        url: $(@).data('href'),
        type: 'post',
        beforeSend: ()->
          $this._ajax_start()
        data: {body: body_json}
        success: (data)->
          $this._ajax_success(data)
          window.location.href = window.location.href.replace(/\/edit/, '')
#          window.location.reload();
        complete: ()->
          $this._ajax_end()
        error: (xhr, msg, e)->
          $this._ajax_error(xhr, msg, e)

  _init_ele_block: ($block)->
    $this = @
    $text = $block.find('>').addClass('text')
    $text.attr('data-placeholder', @options.placeholder)
    $block.attr('data-type', 'HR') if $text.is('hr')

    unless $block.data('block')
      o_block = $this._init_block($block)
      $this._bind_event(o_block)
      $this.tid_arr.push o_block._get_data().tid

  _init_block: ($block)->
    $this = @
    type = $block.data('type')

    o_block = eval("new #{type}($block, $this.options)")
    $block.data('block', o_block)
    o_block

  _bind_event: (o_block)->
    @_bind_block_same_event(o_block)
    @_bind_key_board_event(o_block)

  _bind_block_same_event: (o_block)->
    $this = @

    o_block.$block.focusin ()->
      $this._active_block(o_block)

    # 绑定 导致 area nav 和 block nav 失效
    o_block.$block.focusout ()->
      #unless $this._menu_check() || $this.nav_active
      # $this._inactive_block()

  _bind_key_board_event: (o_block)->
    switch o_block.$block.data('type')
      when 'PixImage'
        @_bind_image_event(o_block)
      when 'HR'
        @_bind_hr_event(o_block)
      when 'Quote'
        @_bind_quote_event(o_block)
      when 'PullQuote'
        @_bind_pull_quote_event(o_block)
      when 'SourceCodeBlock'
        @_bind_source_code_event(o_block)
      when 'VideoFileLink'
        @_bind_video_event(o_block)
      else
        # 'TextBlock'
        @_bind_text_event(o_block)

  _inactive_block: ()->
    if @$active_block
      o_block = @$active_block.data('block')
      o_block._inactive()

      @_ajax_update_block(o_block)

      @$active_block = false

  _force_active_block: (o_block)->
    @$active_block = false
    @_active_block(o_block)

  _active_block: (o_block)->
    unless o_block.$block.is(@$active_block)
      @_inactive_block()
      @$active_block = o_block.$block

      o_block._active()
      o_block.$block.find('.text').focus()

  _add_empty_block: (o_block)->
    $new_block = $("<div class='new block' data-type='TextBlock' data-block-type='P'>
                      <div class='p text'></div>
                    </div>")
    o_block.$block.after($new_block)

    o_new_block = @_init_block($new_block)
    @_bind_event(o_new_block)
    @_active_block(o_new_block)

  _count_text: ()->
    $tbs = @$base.find('[data-type=TextBlock] .text')
    count = 0

    $tbs.each (i, tb)->
      count += $(tb).text().replace(/\s/ig, '').length
    @$counts.text count

  _rebind_text_event: (o_block)->
    $this = @

    o_block.$text.keydown (e)->
      switch e.keyCode
        when 8
          $this._text_key_delete(o_block)
        when 46
          $this._text_key_delete(o_block)
        when 38
          $this._text_key_up(o_block)
        when 40
          $this._text_key_down(o_block)
        else
          true

    o_block.$text.keyup (e)->
      $this._count_text()
      o_block._init_nav()

      switch e.keyCode
        when 13
          $this._text_key_enter(o_block)
        else
          true

  _show_modal: (obj_modal, $block)->
    $click = obj_modal.$clicks.first()
    $click.data('block', $block)
    $click.click()

  _bind_text_event: (o_block)->
    @_rebind_text_event(o_block)

    $this = @
    o_block.$area_nav.find('.tags a').click ()->
      o_block._change_type($(@).text())
      $this._rebind_text_event(o_block)
      o_block.$block.find('.text').focus()

    o_block.$block.find('.text').click ()->
      $(@).focus()

    o_block.$block_nav.find('li a').click ()->
      switch $(@).data('action')
        when 'PixImage'
          # show modal
          $this._show_modal($this.obj_pix_image_modal, o_block.$block)
        when 'HR'
          $this._change_block_to_HR(o_block)
        when 'Quote'
          $this._show_modal($this.obj_quote_modal, o_block.$block)
        when 'VideoFileLink'
          $this._show_modal($this.obj_video_modal, o_block.$block)
        when 'SourceCodeBlock'
          $this._show_modal($this.obj_source_code_modal, o_block.$block)
        else
          console.log $(@).data('action')

  _bind_hr_event: (o_block)->
    $this = @

    o_block.$text.keydown (e)->
      switch e.keyCode
        when 8
          $this._hr_key_delete(o_block)
        when 46
          $this._hr_key_delete(o_block)
        when 38
          $this._hr_key_up(o_block)
        when 40
          $this._hr_key_down(o_block)
        when 13
          $this._hr_key_enter(o_block)
        else
          true
    @_enable_input(o_block.$text)

  _bind_quote_event: (o_block)->
    $this = @

    o_block.$text.keydown (e)->
      switch e.keyCode
        when 38
          $this._quote_key_up(o_block)
        when 40
          $this._quote_key_down(o_block)
        when 13
          $this._quote_key_enter(o_block)
        else
          true

    o_block.$block_edit_nav.click ()->
      $click = $this.obj_quote_modal.$clicks.first()
      $click.data('block', o_block.$block)
      $click.click()

    o_block.$block_del_nav.click ()->
      $this._quote_key_delete(o_block)

    @_enable_input(o_block.$text)

  _bind_pull_quote_event: (o_block)->
    @_rebind_text_event(o_block)

  _bind_video_event: (o_block)->
    $this = @

    o_block.$text.keydown (e)->
      switch e.keyCode
        when 38
          $this._quote_key_up(o_block)
        when 40
          $this._quote_key_down(o_block)
        when 13
          $this._quote_key_enter(o_block)
        else
          true

    o_block.$block_edit_nav.click ()->
      $click = $this.obj_video_modal.$clicks.first()
      $click.data('block', o_block.$block)
      $click.click()

    o_block.$block_del_nav.click ()->
      $this._quote_key_delete(o_block)

    @_enable_input(o_block.$text)

  _bind_source_code_event: (o_block)->
    $this = @

    o_block.$text.keydown (e)->
      switch e.keyCode
        when 38
          $this._quote_key_up(o_block)
        when 40
          $this._quote_key_down(o_block)
        when 13
          $this._quote_key_enter(o_block)
        else
          true

    o_block.$block_edit_nav.click ()->
      $click = $this.obj_source_code_modal.$clicks.first()
      $click.data('block', o_block.$block)
      $click.click()

    o_block.$block_del_nav.click ()->
      $this._quote_key_delete(o_block)

    @_enable_input(o_block.$text)

  _bind_image_event: (o_block)->
    $this = @

    o_block.$text.keydown (e)->
      switch e.keyCode
        when 38
          $this._img_key_up(o_block)
        when 40
          $this._img_key_down(o_block)
        when 13
          $this._img_key_enter(o_block)
        else
          true

    if o_block.$pen_nav
      o_block.$pen_nav.find('i').click ()->
        o_block._change_type($(@).data('action'))
        $this._inactive_block()
        $this._active_block(o_block)

    if o_block.$block_edit_nav
      o_block.$block_edit_nav.click ()->
        $this._show_modal($this.obj_pix_image_modal, o_block.$block)

    o_block.$block_del_nav.click ()->
      $this._img_key_delete(o_block)

    @_enable_input(o_block.$text)

  _change_block_to_HR: (o_block)->
    $new_block = $("<div class='block' data-type='HR'>
                      <div class='text'><hr /></div>
                    </div>")
    $new_block.attr('id', o_block.$block.attr('id'))
    o_block.$block.replaceWith($new_block)

    new_o_block = @_init_block($new_block)
    @_bind_event(new_o_block)

    @_force_active_block(new_o_block)

  # TODO: Rewrite
  _append_image_block: ($prev, html)->
    $this = @
    $this._inactive_block()

    $img_block = $(html)
    $prev.after($img_block)

    $('body').lazing_load
      loadEnd: ()->
        $this._init_block($img_block)
        $this._bind_event($img_block)
        $this._active_block($img_block)

  _refresh_text_block: (o_block, $html)->
    #o_block.$block.replaceWith($html)
    #new_o_block = @_init_block($html)
    #@_bind_event(new_o_block)
    o_block.$block.attr('id', $html.attr('id'))

  _ajax_update_block: (o_block)->
    if $.inArray(o_block.type, ['TextBlock', 'PullQuote', 'PixImage', 'HR']) >= 0

      $this = @

      data = {}
      data.block = o_block._get_data()

      unless data.block.tid
        $prev = @_get_prev_blcok(o_block.$block)
        data.after = $prev.data('block')._get_data().tid

      $.ajax
        url: $this.options.update_url,
        type: 'post',
        beforeSend: ()->
          $this._ajax_start()
        data: data
        success: (data)->
          $this._ajax_success(data)
          $this._refresh_text_block(o_block, $(data.html)) if data.html && o_block.type == 'TextBlock'
        complete: ()->
          $this._ajax_end()
        error: (xhr, msg, e)->
          $this._ajax_error(xhr, msg, e)

  # with ajax
  _destroy_block: (o_block)->
    $near = @_get_near_block(o_block.$block)
    near_o_block = $near.data('block')
    @_ajax_destroy_block(o_block, near_o_block) if near_o_block

  _destroy_block_dom: (o_block, near_o_block)->
    @_force_active_block(near_o_block)
    o_block.$block.remove()

  _ajax_destroy_block: (o_block, near_o_block)->
    $this = @
    tid = o_block._get_data().tid

    if tid
      $.ajax
        url: $this.options.update_url,
        type: 'post',
        beforeSend: ()->
          $this._ajax_start()
        data: { tid: tid, remove: true }
        success: (data)->
          $this._ajax_success(data)
          $this._destroy_block_dom(o_block, near_o_block)
        error: (xhr, msg, e)->
          $this._ajax_error(xhr, msg, e)
        complete: ()->
          $this._ajax_end()
    else
      $this._destroy_block_dom(o_block, near_o_block)

  # about ajax
  _ajax_start: ()->
    @$status.hide()
    @$updating.show()
    @$message.hide()

  _ajax_end: ()->
    @$status.show()
    @$updating.hide()

  _ajax_success: (data)->
    @$message.text(data.msg)
    @$status_time.text(data.u_at)

  _ajax_error: (xhr, msg, e)->
    @$message.text(msg).show()

  _init_status: ()->
    @$message = $('<div class="msg"></div>').hide()
    @$updating = $('<div class="updating"></div>').hide()

    @$status = $(@options.status_tag).before(@$message).after(@$updating)
    @$status_time = @$status.find('.u_at')

  _init_modals: ()->
    @_init_pix_image_modal() if $.inArray('PixImage', @options.blockList) >= 0
    @_init_quote_modal() if $.inArray('Quote', @options.blockList) >= 0
    @_init_source_code_modal() if $.inArray('SourceCodeBlock', @options.blockList) >= 0
    @_init_video_modal() if $.inArray('VideoFileLink', @options.blockList) >= 0

  _init_video_modal: ()->
    @$video_modal = $(@options.modals.video_file_link.modal)
    @obj_video_upload = @$video_modal.find('.block').video_file_link_upload()

    $this = @

    $this.obj_video_modal = @$video_modal.bootstrap_modal
      clicks: '#create_video_block'
      reset_input: true
      before: ($click, obj)->
        $this._before_show_modal($click, obj, $this.obj_video_upload)

    $this._init_form($this.obj_video_modal)

  _init_pix_image_modal: ()->
    @$pix_image_modal = $(@options.modals.pix_image.modal)
    @obj_pix_image_upload = $('._form.pix_image').pix_image_upload()

    $this = @
    $this.obj_pix_image_modal = $this.$pix_image_modal.bootstrap_modal
      clicks: '#create_pix_image'
      reset_input: true
      before: ($click, obj)->
        $this._before_show_modal($click, obj, $this.obj_pix_image_upload)

    $this._init_form($this.obj_pix_image_modal)

  _init_quote_modal: ()->
    @$quote_modal = $(@options.modals.quote.modal)
    @obj_quote_upload = $('._form.quote').quote_upload()
    @obj_web_link_upload = $('._form.web_link').web_link_upload()

    $this = @
    $this.obj_quote_modal = $this.$quote_modal.bootstrap_modal
      clicks: '#create_quote'
      reset_input: true
      before: ($click, obj)->
        $this.obj_quote_upload._reset_content('open')
        $this.obj_web_link_upload._reset_content()

        console.log($this.$quote_modal.find('.web_link.link_bar.text_max_hidden'))

        $this.$quote_modal.find('.web_link.link_bar.text_max_hidden').remove()
        $this.$quote_modal.find('.web_link.link_bar._form').show()

        $this._before_show_modal($click, obj, $this.obj_quote_upload)

    $this._init_form($this.obj_quote_modal)

  _init_source_code_modal: ()->
    @$source_code_modal = $(@options.modals.source_code_block.modal)
    @obj_source_code_upload = @$source_code_modal.find('.source_code_block').source_code_block_upload()

    $this = @
    $this.obj_source_code_modal = $this.$source_code_modal.bootstrap_modal
      clicks: '#create_source_code_block'
      reset_input: true
      before: ($click, obj)->
        $this._before_show_modal($click, obj, $this.obj_source_code_upload)

    $this._init_form($this.obj_source_code_modal)

  _before_show_modal: ($click, obj_modal, obj_upload)->
    $('[type=submit]').removeAttr('disabled')
    $block = $click.data('block')
    if $block
      obj_modal.$modal.data('block', $block)
      o_block = $block.data('block')
      data = o_block._get_data()

      console.log data
      obj_upload._reset_content_form_data(data)

      @_init_modal_block_form_data(data, obj_modal, $block)
      true
    else
      false

  _init_modal_block_form_data: (data, obj_modal, $block)->
    if data.tid
      obj_modal.$old_input.val(data.tid)
      obj_modal.$after_input.val('')
    else
      $prev = @_get_prev_blcok($block)
      o_prev_block = $prev.data('block')
      prev_data = o_prev_block._get_data()
      obj_modal.$old_input.val('')
      obj_modal.$after_input.val(prev_data.tid)

  _init_modal_input: (obj_modal)->
    obj_modal.$form.find('input[name=after]').remove()
    $old = $("<input type='hidden' value='' name='block[tid]'>").appendTo obj_modal.$form
    $after = $("<input type='hidden' value='' name='after'>").appendTo obj_modal.$form
    obj_modal.$old_input = $old
    obj_modal.$after_input = $after

  _init_form: (obj_modal)->
    $this = @

    $this._init_modal_input(obj_modal)

    obj_modal.$form.ajaxForm
      success: (data)->
        console.log data
        $block = obj_modal.$modal.data('block')
        $this._refresh_block($block, data)
        obj_modal.$modal.modal('hide')
      error: (xhr, status, desc)->
        obj_modal._reset_modal(false)

        obj_modal.$form.ajax_errors
          xhr: xhr
      complete: ()->
        $('[type=submit]').removeAttr('disabled')

  _refresh_base_block: (o_block, $new_block)->
    o_block.$block.replaceWith($new_block)
    new_o_block = @_init_block($new_block)
    @_bind_event(new_o_block)
    @_force_active_block(new_o_block)

  _refresh_block: ($block, data)->
    $this = @

    o_block = $block.data('block')
    $new_block = $(data.html)

    switch data._type
      when 'PixImage'
        $this._refresh_img_block(o_block, $new_block)
      when 'SourceCodeBlock'
        $this._refresh_base_block(o_block, $new_block)
        hljs.highlightBlock($new_block.find('code')[0]);
      when 'VideoFileLink'
        $this._refresh_base_block(o_block, $new_block)
        $('body').lazing_video()._init()
      else
        $this._refresh_base_block(o_block, $new_block)

  _refresh_img_block: (o_block, $new_block)->
    $this = @

    o_block.$block.replaceWith($new_block)
    $new_block.lazing_load
      loadEnd: ()->
        new_o_block = $this._init_block($new_block)
        $this._bind_event(new_o_block)
        $this._force_active_block(new_o_block)
