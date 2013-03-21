vertical_slider = ->
  $( "#green_slider" ).slider(
    range: "min"
    value: user_amount()
    min: 0
    max: 250
  ).slider('disable').css('opacity', 1)

show_price = ->
  $('#price').text("$#{price(user_amount())} / month")

jQuery ->
  if $('body.subscriptions_show').length
    vertical_slider()
    show_price()

price = (users) ->
  amount = (users - 10) * 2
  if amount < 0
    0
  else
    amount

user_amount = ->
  parseInt($('#user_amount').text().match(/\d+/)[0])
