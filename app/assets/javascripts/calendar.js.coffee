display_calendar = ->
  $('#calendar').fullCalendar
    header:
      left: 'month, agendaWeek, agendaDay'
      center: 'title'
    height: 700
    editable: true
    selectable: true
    eventSources:
      [
        url: '/events'
        color: '#0668C0'
        textColor: '#FFF'
        ignoreTimezone: false
      ]
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      update_event(event)
    select: (startDate, endDate, allDay, jsEvent, view) ->
      show_add_event_dialog()

jQuery ->
  if $('body.homes_show').length
    display_calendar()

show_add_event_dialog = ->
  $('#event_dialog').dialog(
    modal: true
    title: "New Event"
  )

update_event = (event) ->
  jQuery.ajax(
    type: "PUT"
    url: "/events/#{event.id}"
    data:
      event:
        starts_at: event.start
        ends_at: event.end
  )


