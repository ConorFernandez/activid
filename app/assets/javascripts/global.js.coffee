jQuery () ->
  $(document).on 'ajaxStart', () ->
    $('.ajax-spinner').show()
  $(document).on 'ajaxStop', () ->
    $('.ajax-spinner').hide()