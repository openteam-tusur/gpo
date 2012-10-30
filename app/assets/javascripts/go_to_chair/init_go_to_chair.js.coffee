@init_go_to_chair = () ->
  $("#go-to-chair .button").hide()
  $("#go-to-chair select").change () ->
    $(this).closest("form").submit()
    true
  true
