# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  showErrors = (selector, errorText) ->
    $('.errors-container').show()
    $(selector, '.errors-container').html(errorText)
  resetErrors = (selector) ->
    $('.errors-container').hide()
    $(selector).text('')

  $('form#checkout').submit -> resetErrors('.payment-errors, .order-errors')
  $('form#checkout').on 'ajax:success', ->
    Stripe.card.createToken
      number: $('#card_number').val()
      cvc: $('#card_cvc').val()
      exp_month: $('#card_exp_month').val()
      exp_year: $('#card_exp_year').val()

      (status, response) ->
        if response.error
          showErrors('.payment-errors', response.error.message)
        else
          alert('Payment Success!')
          token = response['id']

  $('form#checkout').on 'ajax:error', (event, xhr, status)->
    if xhr.status == 400
      json = $.parseJSON(xhr.responseText)
      html = ''
      for name, problems of json.errors
        html += "<p>#{name} #{problem}</p>" for problem in problems
      showErrors('.order-errors', html)
    else
      alert('An unknown error occured. Please try again later.')
