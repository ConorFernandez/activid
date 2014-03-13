jQuery () ->
  $('input:text.persistent, textarea.persistent').on 'change', () ->
    $form = $(this).parents('form')
    $form.submit()
