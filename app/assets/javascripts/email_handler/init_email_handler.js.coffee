@init_email_handler = () ->
  wrapper = $('.email')
  wrapper.on 'ajax:success', (evt, data, status, jqXHR) ->
    $(evt.target).closest('.email').html(jqXHR.responseText)
