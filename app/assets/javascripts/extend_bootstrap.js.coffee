completely_hide_flash_message_on_close = ->
  $('[data-dismiss="alert"]').click( ->
    $(this).parent().parent().hide()
  )

jQuery ->
  completely_hide_flash_message_on_close()