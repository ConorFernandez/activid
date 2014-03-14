jQuery ()->
  $('form.fileupload').fileupload
    url: '/endpoint'
    dataType: 'xml'

    add: (event, data) ->
      console.log 'Added', data
      data.submit()

    send: (e, data) ->
      $('#upload-progress').fadeIn()

    progress: (e, data) ->
      percent = Math.round( (e.loaded / e.total) * 100)
      $('#upload-progress .progress-bar').css('width', percent + '%')

    fail: (e, data) ->
      console.log 'Complete Failure!'

    success: (data) ->
      console.log 'Success', data

    done: (event, data) ->
      $('#upload-progress').fadeOut 300, () ->
        $('#upload-progress .progress-bar').css(width: 0)