jQuery () ->
  $(document).on 'ajaxStart', () ->
    $('.ajax-spinner').show()
    # Disable all navigation links
    $('.navigation a').addClass('disabled')

  $(document).on 'ajaxStop', () ->
    $('.ajax-spinner').hide()

    $('.navigation a').removeClass('disabled')


