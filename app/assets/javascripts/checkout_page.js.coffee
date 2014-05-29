jQuery ->
  $('.checkout-btn button').on 'click', ->
    $('form#checkout').submit()
