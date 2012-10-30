$ ->
  init_attention() if $('.attention').length
  init_datepicker() if $('input.datepicker').length
  init_go_to_chair() if $("#go-to-chair").length
  init_gpodays() if $(".rating .wrapper").length
  init_hint() if $("#hint").length
  init_actions_form() if $("#right #actions form").length
  true
