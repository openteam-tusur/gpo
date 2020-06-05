$ ->
  init_attention() if $('.attention').length
  init_datepicker() if $('input.datepicker').length
  init_go_to_chair() if $('#go-to-chair').length
  init_go_to_chair_statistics() if $('.go-to-chair-statistics').length
  init_gpodays() if $('.rating .wrapper').length
  init_hint() if $('#hint').length
  init_actions_form() if $('#right #actions form').length
  init_opening_order_state_event() if $('input#order_state_event').length
  init_users_autocomplete() if $('.users_autocomplete').length
  init_project_category() if $('#project_category').length

  return
