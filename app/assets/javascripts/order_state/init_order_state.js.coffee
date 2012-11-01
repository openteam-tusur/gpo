@init_opening_order_state_event = () ->
  hidden = $('#opening_order_state_event')
  form = hidden.closest("form")
  button = $("input[type=submit]", form)
  console.log
  button.click (event) ->
    hidden.attr("name", $(this).attr("name"))
    true
  form.submit (event) ->
    hidden.attr("name", button.first().attr("name"))
    true
  true
