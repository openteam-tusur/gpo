@init_actions_form = () ->
  $("#right #actions form input[type=submit]").each (index, item) ->
    button = $(this).hide()
    form = button.closest("form")
    link = $("<a href='#' class='submit'>#{button.attr("value")}</a>").insertBefore(button)
    link.click (event) ->
      form.submit()
      false
    true
  true
