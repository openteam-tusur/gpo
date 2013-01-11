@init_go_to_chair = () ->
  $('#go-to-chair .button').hide()
  $('#go-to-chair select').change () ->
    href = $(this).attr('name')
    chair_id = $('option:selected', $(this)).val()
    window.location.href = href.replace('[chair]', "/#{chair_id}") if chair_id
    false
  true
