@init_gpodays = () ->
  $(".rating .wrapper").each (index, item) ->
    width_wrapper = 0
    $(".gpoday", this).each (index, item) ->
      width_wrapper += $(this).width()
    $(this).width(width_wrapper)
    $(this).parent().scrollTo($("div.gpoday:last", this))
    true
  true
