jQuery ->
  template = $('#discount').text()

  showErrors = (selector, errorText) ->
    $('.errors-container').show()
    $(selector, '.errors-container').html(errorText)
  resetErrors = (selector) ->
    $('.errors-container').hide()
    $(selector).text('')

  $('form#coupon_form').submit -> resetErrors('.order-errors')

  $('form#coupon_form').on 'ajax:success', (xhr, data, event)->
    rendered = Mustache.render template,
      order_name: order.name
      old_cost: order.old_cost.toFixed(2)
      coupon_discount: data.discount.toFixed(2)
      coupon_name: data.name
      final_total: data.new_order_cost.toFixed(2)
    $('#order-cost').html(rendered)
    $('.coupon-container').html("<p>You are using the coupon '#{data.name}' for this purchase.</p>")

  $('form#coupon_form').on 'ajax:error', (event, xhr, status)->
    if xhr.status == 400
      json = $.parseJSON(xhr.responseText)
      showErrors('.order-errors', json.error)
    else
      alert('An unknown error occured. Please try again later.')