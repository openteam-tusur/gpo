@init_go_to_chair_statistics = () ->
  $('.go-to-chair-statistics select').change () ->
    window.location.href = $(this).val()
    false
  true
