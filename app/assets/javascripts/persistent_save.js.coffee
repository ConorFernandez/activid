jQuery () ->
  $('input:text.persistent, textarea.persistent, input:radio.persistent').on 'change', () ->
    $form = $(this).parents('form')
    $form.submit()
