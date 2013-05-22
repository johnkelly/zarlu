trigger_uservoice_popup = ->
  $('.support_link').on('click', (e) ->
    e.preventDefault()
    _gaq.push(['_trackPageview', '/vp/support/open'])
    UserVoice.showPopupWidget()
    send_opened_support_tool()
  )

disable_nav = ->
  $('.nav_disabled').click (e) ->
    e.preventDefault()

jQuery ->
  trigger_uservoice_popup()
  disable_nav()

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
