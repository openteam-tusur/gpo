@init_hint = () ->
  $('#tray').append("<span class='hint-switcher'><ins>Инструкция</ins></span>")
  $('#hint').addClass("hint-switcher")
  $('.hint-switcher').click () ->
    $('#hint').fadeToggle('fast')
    false
  true
