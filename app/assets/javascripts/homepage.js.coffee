$ ->
  # Homepage: Synchronize height of jumbotron to that of carousel
  if $('.homepage').length
    $('.homepage .jumbotron .spacer').css('height', $('.wide-image').height())
    $(window).on 'resize', ->
      $('.homepage .jumbotron .spacer').css('height', $('.wide-image').height())
