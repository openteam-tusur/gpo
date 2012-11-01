$ ->
  init_attention() if $('.attention').length
  init_datepicker() if $('input.datepicker').length
  init_go_to_chair() if $("#go-to-chair").length
  init_gpodays() if $(".rating .wrapper").length
  init_hint() if $("#hint").length
  init_actions_form() if $("#right #actions form").length
  init_opening_order_state_event() if $("input#opening_order_state_event").length
  true
