jQuery ->
  $('button.checkout').on 'click', ->
    $('form#checkout').submit()