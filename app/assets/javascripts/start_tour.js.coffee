start_tour_on_click = (tour, type) ->
  $('#start_tour').click (e) ->
    e.preventDefault()
    _gaq.push(['_trackPageview', "/vp/tour/#{type}"])
    tour.restart()
    tour.start()

jQuery ->
  if $('body.homes_show').length
    $('#start_tour').removeClass('hide').text("Tour Calendar")
    calendar_tour = new CalendarTour()
    start_tour_on_click(calendar_tour, "calendar")
  else if $('body.subscribers_show').length
    $('#start_tour').removeClass('hide').text("Tour Account")
    account_tour = new AccountTour()
    start_tour_on_click(account_tour, "account")
