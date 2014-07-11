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

        # Start file uploads automatically.
        data.submit()

      send: (e, data) ->
        #console.log 'Sending File', data


      start: (e, data) ->
        $('button.cancel', form).fadeIn()
        $('#upload-progress').fadeIn()

      stop: (e, data) ->
        $('button.cancel', form).fadeOut()

      progress: (e, data) ->
        percent = ( (data.loaded / data.total) * 100).toFixed(2)
        file = _.first(data.files)
        $('.progress', data.context).show();
        $('.progress-bar', data.context).css('width', percent + '%');
        $('.progress-bar', data.context).text("#{percent}%");

      progressall: (e, data) ->
        percent = ( (data.loaded / data.total) * 100).toFixed(2)
        $('#upload-progress .progress-bar').css('width', percent + '%')
        $('#upload-progress .progress-bar').text("#{percent}%")

      fail: (e, data) ->
        #console.log 'Complete Failure!'

      done: (event, data) ->
        markAsUploaded(data).then ->
          renderSuccessUpload(data)

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
      $(this).fadeOut()
      $('.attached-files .file').each () ->
        fu = $(this).data('fileupload')
        if fu
          fu.submit()

    # Cancel all current and pending uploads.
    $('button.cancel', form).on 'click', () ->
      $('button.start', form).fadeIn()
      $('.attached-files .file').each () ->
        fu = $(this).data('fileupload')
        if fu
          fu.abort()

markAsUploaded = (data) ->
  $.ajax
    type: 'POST'
    url: '/orders/order_files.json'
    dataType: 'json'
    data:
      order_file:
          uploaded_filename: data.renamedFile
          original_filename: data.filename
    success: (json, textStatus, xhr)->
      data.file_id = json.id

deleteUploadedFile = (id) ->
  $.ajax
    type: 'DELETE'
    url: "/orders/order_files/#{id}.json"

# TODO: move into another file when done prototyping
renderFileTemplate = (data, view) ->
  template = $('#upload-file-template').text()
  rendered = $(Mustache.render template, view)
  generatePreview(data, rendered)
  rendered

renderSuccessUpload = (data) ->
  file = _.first(data.files)
  newContext = renderFileTemplate data,
    file_id: data.file_id
    file_name: file.name
    uploadable: false
    done: true

  $(data.context).replaceWith(newContext)
  data.context = newContext

generatePreview = (data, view) ->
  if data.files[0].type.match(/^image/)
    generatePreviewImage(data, view)
  # else if data.files[0].type.match(/^video/)
  #   generatePreviewVideo(data, view)

generatePreviewImage = (data, view) ->
  createObjectURL data.files[0], (blobUrl) ->
    $('.preview img', view).attr('src', blobUrl).removeClass('hidden')

generatePreviewVideo = (data, view) ->
  createObjectURL data.files[0], (blobUrl) ->
    $('.preview video', view).attr('src', blobUrl).removeClass('hidden')

# Polyfill.
createObjectURL = (file, cb) ->
  ns = window.URL || window.webkitURL
  if ns && ns.createObjectURL
    cb(ns.createObjectURL(file))

jQuery () ->
  if window.uploadedFiles
    _.each window.uploadedFiles, (f) =>
      template = $('#upload-file-template').text()
      rendered = Mustache.render template,
        file_id: f.id
        file_name: f.original_filename
        done: true
      $(rendered).appendTo('.attached-files')

# Handle the modal preview dialogs
jQuery ->
  $('#preview-modal').on 'show.bs.modal', (e) ->
    fu = $(e.relatedTarget).parents('.file').data('fileupload')
    file = fu.files[0]
    $('.preview img, .preview video', this).addClass('hidden')
    $('span.filename', this).text(file.name)
    generatePreview fu, $('#preview-modal')

# Handle removing files
jQuery ->
  $('.attached-files').on 'click', '.file .delete', ->
    fileDiv = $(this).parents('.file')
    fileId  = $(fileDiv).find('input[name="file_id"]').val()

    deleteUploadedFile(fileId)
    fileDiv.remove()

  $('.attached-files').on 'click', '.file .cancel', ->
    fileDiv = $(this).parents('.file')
    fu = fileDiv.data('fileupload')
    fu.abort()
    fileDiv.remove()
