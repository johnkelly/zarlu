get_gravatar_for_email = ->
  $('#user_email').blur(->
    email = $('#user_email').val()
    $('.img-circle').attr('src', 'http://www.gravatar.com/avatar/' + $.md5(email))
  )

jQuery ->
  get_gravatar_for_email()

$(document).bind('page:change', ->
  get_gravatar_for_email()
)