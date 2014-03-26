jQuery ()->
  $('form.fileupload').each ()->
    form = $(this)

    $(form).fileupload
      url: form.attr('action')
      dataType: 'xml'
      sequentialUploads: true

      add: (event, data) ->
        # Track Data so that we can call data.cancel if the user selects the wrong file.
        data.filename = _.first(data.files).name
        data.context = renderFileTemplate data,
          file_name: data.filename
          uploadable: true

        $(data.context)
          .data('fileupload', data)
          .appendTo('.attached-files')
          .find('.remove').on('click', ()-> $(this).parents('.file').remove() )
          .end()

      send: (e, data) ->
        console.log 'Sending File', data


      start: (e, data) ->
        $('button.cancel', form).fadeIn()

      stop: (e, data) ->
        $('button.cancel', form).fadeOut()

      progress: (e, data) ->
        percent = ( (data.loaded / data.total) * 100).toFixed(2)
        file = _.first(data.files)
        $('.progress', data.context).show();
        $('.progress-bar', data.context).css('width', percent + '%');
        $('.progress-bar', data.context).text("#{percent}%");
        # The data object we're expecting (the file upload) isn't present in the success handler.
        # Therefore, this cheap hack does the same thing.
        if data.loaded == data.total
          markAsUploaded(data)
          renderSuccessUpload(data)

      progressall: (e, data) ->
        percent = ( (data.loaded / data.total) * 100).toFixed(2)
        $('#upload-progress .progress-bar').css('width', percent + '%')
        $('#upload-progress .progress-bar').text("#{percent}%")

      fail: (e, data) ->
        console.log 'Complete Failure!'

      done: (event, data) ->
        console.log 'Successfully uploaded all files!'

    # TODO: this should work with file resume... so long as they don't leave the page.
    # We're transforming the file name to include a unique key
    # This key is appended with seconds since UNIX epoch.
    $(form).on 'fileuploadsubmit', (e, data) ->
      formData = form.serializeArray()
      key =  _.find(formData, (hash)-> hash.name == 'key')
      filename = data.filename
      extension = _.last(filename.split('.'))
      epoch = Math.round new Date().getTime() / 1000

      regex = new RegExp("\.(#{extension})$")
      key.value = key.value + filename.replace(regex, "_#{epoch}.$1")

      data.formData = formData
      data.renamedFile = key.value
      true

    # Start all uploads when user clicks the 'start' button
    $('button.start', form).on 'click', () ->
      $('.attached-files .file').each () ->
        fu = $(this).data('fileupload')
        if fu
          fu.submit()

    # Cancel all current and pending uploads.
    $('button.cancel', form).on 'click', () ->
      $('.attached-files .file').each () ->
        fu = $(this).data('fileupload')
        if fu
          fu.abort()

markAsUploaded = (data) ->
  $.ajax
    type: 'PUT'
    url: '/orders'
    data:
      order:
        'order_files_attributes': [
          uploaded_filename: data.renamedFile
          original_filename: data.filename
        ]

# TODO: move into another file when done prototyping
renderFileTemplate = (data, view) ->
  template = $('#upload-file-template').text()
  rendered = $(Mustache.render template, view)
  generatePreview(data, rendered)
  rendered

renderSuccessUpload = (data) ->
  file = _.first(data.files)
  newContext = renderFileTemplate data,
    file_name: file.name
    uploadable: false
    done: true

  $(data.context).replaceWith(newContext)
  data.context = newContext

generatePreview = (data, view) ->
  if data.files[0].type.match(/^image/)
    generatePreviewImage(data, view)
  else if data.files[0].type.match(/^video/)
    generatePreviewVideo(data, view)

generatePreviewImage = (data, view) ->
  createObjectURL data.files[0], (blobUrl) ->
    $('.preview img', view).attr('src', blobUrl).show()

generatePreviewVideo = (data, view) ->
  createObjectURL data.files[0], (blobUrl) ->
    $('.preview video', view).attr('src', blobUrl).show()

# Polyfill.
createObjectURL = (file, cb) ->
  ns = URL || webkitURL
  if ns && ns.createObjectURL
    cb(ns.createObjectURL(file))

jQuery () ->
  if window.uploadedFiles
    _.each window.uploadedFiles, (f) =>
      template = $('#upload-file-template').text()
      rendered = Mustache.render template,
        file_name: f.original_filename
        done: true
      $(rendered).appendTo('.attached-files')

