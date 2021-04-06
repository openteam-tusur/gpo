@init_datepicker = () ->
  $('input.datepicker').datepicker
    showOn: "button"
    buttonImage: "/assets/datepicker.gif"
    buttonImageOnly: true
  true
