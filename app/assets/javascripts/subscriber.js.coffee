activate_best_in_place = ->
  $(".best_in_place").best_in_place()

jQuery ->
  if $('body.subscribers_show').length
    activate_best_in_place()
