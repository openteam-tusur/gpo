@init_search = () ->
  $(document).ready ->
    input = $('.js-search-input')
    input.on 'keyup', ->
      value = $(this).val().toLowerCase()

      $('.js-search-item').filter ->
        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)

      if($('.js-search-item:visible').length == 0) && $('.js-search-not-found').length == 0
        $('.js-search-item-container').after( "<p class='js-search-not-found'>По вашему запросу ничего не найдено</p>" )
        
      else if $('.js-search-item:visible').length != 0
        $('.js-search-not-found').remove()
