jQuery ()->
  template = $('#upload-file-template').text()

  $('form.fileupload').each ()->
    form = $(this)

    $(form).fileupload
      url: form.attr('action')
      dataType: 'xml'
      sequentialUploads: true
      maxChunkSize: 10485760 # Ten Megabyte chunks

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
        console.log 'Sending File', data
        $('#upload-progress').fadeIn()

      progressall: (e, data) ->
        percent = Math.round( (data.loaded / data.total) * 100)
        $('#upload-progress .progress-bar').css('width', percent + '%')
        $('#upload-progress .progress-bar').text("#{percent}%")

      fail: (e, data) ->
        console.log 'Complete Failure!'

      success: (data) ->
        console.log 'Success!', data

      done: (event, data) ->
        console.log 'Successfully uploaded all files!'

    $('button.start', 'form.fileupload').on 'click', () ->
      $('.attached-files .file').each () ->
        fu = $(this).data('fileupload')
        fu.submit()
