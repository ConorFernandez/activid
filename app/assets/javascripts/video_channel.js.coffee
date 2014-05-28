$ ->
  $('.video-channel .all-videos li').on 'click', (e) ->
    el = $(this)
    thisVideo = el.parents('.video-channel').children('.this-video')
    thisVideo.children('.vimeo').attr('src', el.data('videourl'))
    thisVideo.children('h2').html(el.children('.title').html())
    el.siblings().removeClass('selected')
    el.addClass('selected')
