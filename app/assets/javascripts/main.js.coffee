$ ->
  init_datepicker() if $('input.datepicker').length
  init_go_to_chair() if $("#go-to-chair").length
  init_gpodays() if $(".rating .wrapper").length
  true
