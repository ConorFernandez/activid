jQuery ()->
  template = $('#upload-file-template').text()

  $('form.fileupload').each ()->
    form = $(this)

    $(form).fileupload
      url: form.attr('action')
      dataType: 'xml'

      add: (event, data) ->
        # Track Data so that we can call data.cancel if the user selects the wrong file.
        console.log 'Added', data
        file = _.first(data.files)

        rendered = Mustache.render template,
          file_name: file.name
          uploadable: true

        $(rendered)
          .data('fileupload', data)
          .appendTo('.attached-files')
          .find('.remove').on('click', ()-> $(this).parents('.file').remove() )
          .end()

      send: (e, data) ->
        $('#upload-progress').fadeIn()

      progressall: (e, data) ->
        percent = Math.round( (e.loaded / e.total) * 100)
        $('#upload-progress .progress-bar').css('width', percent + '%')

      fail: (e, data) ->
        console.log 'Complete Failure!'

      success: (data) ->
        console.log 'Success', data

      done: (event, data) ->
        console.log 'Successfully uploaded all files!'
        $('#upload-progress').fadeOut 300, () ->
          $('#upload-progress .progress-bar').css(width: 0)

    $('button.start', 'form.fileupload').on 'click', () ->
      files = []
      $('.attached-files .file').each () ->
        files.push _.first($(this).data('fileupload').files)

      $('form.fileupload').fileupload('send', files: files)