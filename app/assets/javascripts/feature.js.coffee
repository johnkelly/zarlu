scroll_to_header = ->
  $('.scroll_link').click ->
    type = $(this).attr('id')
    set_color_and_clear_others(this, type)
    $('html, body').animate(
      scrollTop: $("##{type}_header").offset().top - 215
      1000
    )

jQuery ->
  if $('body.homes_features').length
    scroll_to_header()

set_color_and_clear_others = (div, type) ->
    $('.scroll_link').css("color", "#000")
    $(div).css("color", color(type))


color = (id) ->
  switch id
    when "attendance"
      "#0668C0"
    when "data"
      "green"
    when "customization"
      "#FF5E00"
    when "technology"
      "purple"

