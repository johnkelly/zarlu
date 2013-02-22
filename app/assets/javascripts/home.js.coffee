trigger_uservoice_popup = ->
  $('#support_link').on('click', (e) ->
    e.preventDefault()
    UserVoice.showPopupWidget()
  )

jQuery ->
  trigger_uservoice_popup()
