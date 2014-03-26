jQuery () ->
  $(document).on 'ajaxStart', () ->
    $('.ajax-spinner').show()
    # Disable all navigation links
    $('.navigation a').addClass('disabled')

  $(document).on 'ajaxStop', () ->
    $('.ajax-spinner').hide()

    $('.navigation a').removeClass('disabled')

  $(window).on 'beforeunload', ->
    unless jQuery.active == 0
      return "Looks like we're still working on your stuff. If you leave, you may lose some data. Are you sure?"
    return
