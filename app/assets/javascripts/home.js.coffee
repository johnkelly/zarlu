get_gravatar_for_email = ->
  $('#user_email').blur(->
    email = $('#user_email').val()
    $('.img-circle').attr('src', 'https://secure.gravatar.com/avatar/' + $.md5(email))
  )

trigger_uservoice_popup = ->
  $('#support_link').on('click', (e) ->
    e.preventDefault()
    UserVoice.showPopupWidget()
  )

jQuery ->
  get_gravatar_for_email()
  trigger_uservoice_popup()
