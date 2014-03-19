# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('form#checkout').submit -> $('.payment-errors-container').hide().find('.payment-errors').text('')
  $('form#checkout').on 'ajax:success', ->
    Stripe.card.createToken
      number: $('#card_number').val()
      cvc: $('#card_cvc').val()
      exp_month: $('#card_exp_month').val()
      exp_year: $('#card_exp_year').val()

      (status, response) ->
        if response.error
          $('.payment-errors-container').show()
          $('.payment-errors').text(response.error.message)
        else
          alert('Payment Success!')
          token = response['id']
