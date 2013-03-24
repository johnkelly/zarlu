trigger_uservoice_popup = ->
  $('.support_link').on('click', (e) ->
    e.preventDefault()
    _gaq.push(['_trackPageview', '/vp/support/open'])
    UserVoice.showPopupWidget()
  )

jQuery ->
  trigger_uservoice_popup()
