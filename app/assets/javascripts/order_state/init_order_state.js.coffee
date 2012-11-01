@init_opening_order_state_event = () ->
  hidden = $('#order_state_event')
  form = hidden.closest("form")
  button = $("input[type=submit]", form)

  button.click (event) ->
    hidden.val($(this).attr("name"))
    true

  form.submit (event) ->
    hidden.val(button.first().attr("name"))
    true

  true
