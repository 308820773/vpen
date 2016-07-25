$.fn.v_editor = (options)->
  $this = @

  defaults =
    editorSelect: '.block'
    placeholder: '请输入文字'
    reload_alert: '文章可能不会保存'
    debug: false
    stay: true
    submit_button: '#publish'
    text_list: ['code', 'bold', 'italic', 'createlink']
    image_list: ['code', 'bold', 'italic']
    areaList: ['H3', 'H4', 'H5', 'P', 'CP', 'RP', 'OL', 'UL']
    blockList: ['Quote', 'PixImage', 'HR', 'SourceCodeBlock', 'VideoFileLink']
    status_tag: '.action_bar .save_time'
    modals:
      pix_image:
        modal: '#create_pix_image_modal'
        cache_url: '/ajax/curations/pix_img/cache'
      quote:
        modal: '#create_quote_modal'
      source_code_block:
        modal: '#create_source_code_modal'
      video_file_link:
        modal: '#create_video_modal'
    upload_image: ()->
    upload_quote: ()->

  options = $.extend true, {}, defaults, options

  unless $this.data('Editor')
    $this.data('Editor', new Editor($this, options))
