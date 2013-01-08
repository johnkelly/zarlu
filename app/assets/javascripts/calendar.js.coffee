display_calendar = ->
  $('#calendar').fullCalendar
    header:
      left: 'month, agendaWeek, agendaDay'
      center: 'title'
    height: 700
    editable: true
    eventSources:
      [
        url: '/events'
        color: '#0668C0'
        textColor: '#FFF'
        ignoreTimezone: false
      ]
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      update_event(event)
jQuery ->
  if $('body.homes_show').length
    display_calendar()

update_event = (event) ->
  jQuery.ajax(
    type: "PUT"
    url: "/events/#{event.id}"
    data:
      event:
        starts_at: event.start
        ends_at: event.end
  )


