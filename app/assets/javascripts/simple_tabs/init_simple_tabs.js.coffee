@init_simple_tabs = () ->
  simple_tabs_wrapper = $('.js-simple-tabs-wrapper')
  $('.tabgroup > div', simple_tabs_wrapper).hide()
  $('.tabgroup > div:first-of-type', simple_tabs_wrapper).show()
  $('.js-simple-tabs a', simple_tabs_wrapper).click (e) ->
    e.preventDefault()
    $this = $(this)
    tabgroup = '#' + $this.parents('.js-simple-tabs', simple_tabs_wrapper).data('tabgroup')
    others = $this.closest('li').siblings().children('a')
    target = $this.attr('href')
    others.removeClass 'active'
    $this.addClass 'active'
    $(tabgroup).children('div').hide()
    $(target).show()
  return
