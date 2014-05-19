jQuery () ->
  $(document).on 'ajaxStart', () ->
    $('.ajax-spinner').removeClass('inactive')
    # Disable all navigation links
    $('.navigation a').addClass('disabled')

  $(document).on 'ajaxStop', () ->
    $('.ajax-spinner').addClass('inactive')

    $('.navigation a').removeClass('disabled')

  $(window).on 'beforeunload', ->
    unless jQuery.active == 0
      return "Looks like we're still working on your stuff. If you leave, you may lose some data. Are you sure?"
    return

  # Homepage: Synchronize height of jumbotron to that of carousel
  if $('.homepage').length
    $('.homepage .jumbotron').height($('.wide-image').height())
    $(window).on 'resize', ->
      $('.homepage .jumbotron').height($('.wide-image').height())
