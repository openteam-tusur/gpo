@init_hint = () ->
  $('#tray').append("<span class='hint-switcher hint-button button primary'>Инструкция</span>")
  $('#hint').addClass("hint-switcher")
  $('.hint-switcher').click () ->
    $('#hint').fadeToggle('fast')
    false
  true
