@init_project_category = ->
  $(document).ready ->
    changeCategory()

  changeCategory = () ->
    company = $('.project_company')
    if $('#project_category').val() == 'by_request'
      company.show()
    else
      company.hide()

  $('#project_category').on 'change', changeCategory
