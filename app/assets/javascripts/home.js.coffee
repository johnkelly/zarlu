trigger_uservoice_popup = ->
  $('.support_link').on('click', (e) ->
    e.preventDefault()
    UserVoice.showPopupWidget()
    send_opened_support_tool()
  )

disable_nav = ->
  $('.nav_disabled').click (e) ->
    e.preventDefault()

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

jQuery ->
  trigger_uservoice_popup()
  disable_nav()
  video_play_list()
  video_click_listeners()

reset_videos = ->
  console.log "Called?"
  $('div').removeClass("selected_video")
  $('video').hide()

play_video = (type) ->
  video = $("##{type}_video").get(0)
  video.pause()
  video.currentTime = 0
  $("#play_#{type}").addClass("selected_video")
  $("##{type}_video").show()
  video.play()

send_opened_support_tool = ->
  if $('.welcomes_show').length || $('.employee_welcomes_show').length
    $.ajax(
      type: "POST"
      url: "/welcomes"
      data:
        support: "true"
      success: ->
        $('#contact_support_task').prop("disabled", false)
        $('#contact_support_task').prop("checked", true)
        $('#contact_support_task').prop("disabled", true)
    )
