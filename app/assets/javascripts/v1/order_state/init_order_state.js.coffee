@init_opening_order_state_event = () ->
  hidden = $('#order_state_event')
  form = hidden.closest("form")

  $('.button', form).on 'click', (evt) ->
    hidden.val $(evt.target).attr('name')

  true
