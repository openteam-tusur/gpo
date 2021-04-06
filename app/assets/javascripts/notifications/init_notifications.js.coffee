@init_notifications = () ->
  flash_message = $('.flash_message:visible')
  $(window).on 'click', ->
    flash_message.clearQueue().slideUp('fast')
  flash_message.delay(15000).slideUp('fast')
