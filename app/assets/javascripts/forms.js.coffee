jQuery ->
  styleRadioButtons = ->
    $('.btn-group.radios .btn input:checked').parents('.btn').addClass('active')

  $(".btn-group.radios .btn input[type='radio']").on 'change', ->
    $(this).parents('.btn-group').find('.btn').removeClass('active')
    $(this).parents('label.btn')
    styleRadioButtons()

  styleRadioButtons()