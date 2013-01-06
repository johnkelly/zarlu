display_calendar = ->
  $('#calendar').fullCalendar
    header:
      left: 'month, agendaWeek, agendaDay'
      center: 'title'
    height: 700
jQuery ->
  if $('body.homes_show').length
    display_calendar()
