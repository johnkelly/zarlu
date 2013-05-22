start_tour_on_click = (tour, type) ->
  $('#start_tour, .tour').click (e) ->
    e.preventDefault()
    _gaq.push(['_trackPageview', "/vp/tour/#{type}"])
    tour.restart()
    tour.start()
    send_started_welcome_tour() if type is "welcome"

send_started_welcome_tour = ->
  $.ajax(
    type: "POST"
    url: "/welcomes"
    success: ->
      $('#welcome_tour_task').prop("disabled", false)
      $('#welcome_tour_task').prop("checked", true)
      $('#welcome_tour_task').prop("disabled", true)
  )

jQuery ->
  if $('body.homes_show').length
    $('#start_tour').removeClass('hide').text("Tour Calendar")
    calendar_tour = new CalendarTour()
    start_tour_on_click(calendar_tour, "calendar")
  else if $('body.subscribers_show').length
    $('#start_tour').removeClass('hide').text("Tour Employees")
    account_tour = new AccountTour()
    start_tour_on_click(account_tour, "account")
  else if $('body.activities_index').length
    $('#start_tour').removeClass('hide').text("Tour Activity Feed")
    account_tour = new ActivityFeedTour()
    start_tour_on_click(account_tour, "activity_feed")
  else if $('body.welcomes_show').length
    $('#start_tour').removeClass('hide').text("Welcome Tour")
    welcome_tour = new WelcomeTour()
    start_tour_on_click(welcome_tour, "welcome")
  else if $('body.employee_welcomes_show').length
    $('#start_tour').removeClass('hide').text("Welcome Tour")
    employee_welcome_tour = new EmployeeWelcomeTour()
    start_tour_on_click(employee_welcome_tour, "welcome")
