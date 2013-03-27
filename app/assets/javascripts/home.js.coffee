trigger_uservoice_popup = ->
  $('.support_link').on('click', (e) ->
    e.preventDefault()
    _gaq.push(['_trackPageview', '/vp/support/open'])
    UserVoice.showPopupWidget()
  )

disable_nav = ->
  $('.nav_disabled').click (e) ->
    e.preventDefault()

jQuery ->
  trigger_uservoice_popup()
  disable_nav()
