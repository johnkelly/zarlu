video_demo = ->
  video_play_list()
  video_click_listeners()

image_demo = ->
  $('video').remove()
  image_click_listeners()
  $('#play_time_off').click()


jQuery ->
  if $('body.homes_index').length
    if supports_video() and not ios()
      video_demo()
    else
      image_demo()

supports_video = ->
  document.createElement('video').canPlayType

ios = ->
  navigator.userAgent.match(/(iPad|iPhone|iPod)/g)?

image_click_listeners = ->
  $('#play_time_off').click ->
    $('div').removeClass("selected_video")
    $(this).addClass("selected_video")
    $('.image_backup').addClass('hide')
    $('#time_off_backup').removeClass('hide')

  $('#play_approve').click ->
    $('div').removeClass("selected_video")
    $(this).addClass("selected_video")
    $('.image_backup').addClass('hide')
    $('#approve_backup').removeClass('hide')

  $('#play_chart').click ->
    $('div').removeClass("selected_video")
    $(this).addClass("selected_video")
    $('.image_backup').addClass('hide')
    $('#chart_backup').removeClass('hide')

  $('#play_settings').click ->
    $('div').removeClass("selected_video")
    $(this).addClass("selected_video")
    $('.image_backup').addClass('hide')
    $('#settings_backup').removeClass('hide')


video_click_listeners = ->
  $('#play_time_off').on("click", ->
    reset_videos()
    play_video("time_off")
  )

  $('#play_approve').on("click", ->
    reset_videos()
    play_video("approve")
  )

  $('#play_chart').on("click", ->
    reset_videos()
    play_video("chart")
  )

  $('#play_settings').on("click", ->
    reset_videos()
    play_video("settings")
  )

video_play_list = ->
  $("#time_off_video").bind("ended", ->
    $('#play_approve').click()
  )

  $("#approve_video").bind("ended", ->
    $('#play_chart').click()
  )

  $("#chart_video").bind("ended", ->
    $('#play_settings').click()
  )

  $("#settings_video").bind("ended", ->
    $('#play_time_off').click()
  )

reset_videos = ->
  $('div').removeClass("selected_video")
  $('video').hide()

play_video = (type) ->
  video = $("##{type}_video").get(0)
  video.pause()
  video.currentTime = 0
  $("#play_#{type}").addClass("selected_video")
  $("##{type}_video").show()
  video.play()
