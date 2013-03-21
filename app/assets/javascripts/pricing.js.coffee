user_slider = ->
  $( "#green_slider" ).slider(
    range: "min"
    value: 10
    min: 0
    max: 250
    slide: (event, ui) ->
      $('#user_amount').text("#{ui.value} Employees / Managers")
      $('#price').text("$#{price(ui.value)} / month")
  )

jQuery ->
  if $('body.homes_pricing').length
    user_slider()

price = (users) ->
  amount = (users - 10) * 2
  if amount < 0
    0
  else
    amount
