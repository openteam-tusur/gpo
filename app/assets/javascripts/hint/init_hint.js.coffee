@init_hint = () ->
  $('#tray').append("<img class='hint-switcher' src='/assets/icon-help.png' />")
  $('#hint').addClass("hint-switcher")
  $('.hint-switcher').click () ->
    $('#hint').fadeToggle('fast')
    false
  true
