display_calendar = ->
  $('#calendar').fullCalendar
    header:
      left: 'month, agendaWeek, agendaDay'
      center: 'title'
    height: 700
    editable: true
    selectable: true
    slotMinutes: 15
    eventSources:
      [
        url: '/events'
        color: '#0668C0'
        textColor: '#FFF'
        ignoreTimezone: true
      ]
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      update_event(event)
    eventResize: (event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view) ->
      update_event(event)
    eventClick: (event, jsEvent, view) ->
      show_edit_event_dialog(event, jsEvent, view)
    select: (startDate, endDate, allDay, jsEvent, view) ->
      show_add_event_dialog(startDate, endDate, allDay, jsEvent, view)

jQuery ->
  if $('body.homes_show').length
    display_calendar()

show_add_event_dialog = (startDate, endDate, allDay, jsEvent, view) ->
  $('#event_dialog').dialog(
    modal: true
    title: "New Event"
    buttons:
      [
        text: "Save"
        click: ->
          create_event(get_dialog_title(), startDate, endDate, allDay, jsEvent, view)
      ]
  )

show_edit_event_dialog = (event, jsEvent, view) ->
  $('#event_dialog').dialog(
    modal: true
    title: "Edit Event"
    buttons:
      [{
        text: "Save"
        click: ->
          update_event(event)
      },
      {
        text: "Delete"
        click: ->
          delete_event(event)
      }]
  )

create_event = (title, startDate, endDate, allDay, jsEvent, view) ->
  $.ajax(
    type: "POST"
    url: "/events"
    data:
      event:
        title: title
        description: ""
        starts_at: startDate
        ends_at: endDate
        all_day: allDay
    success: ->
      close_dialog()
  )

update_event = (event) ->
  event_title = get_dialog_title()
  new_title = if !!event_title then event_title else event.title
  $.ajax(
    type: "PUT"
    url: "/events/#{event.id}"
    data:
      event:
        title: new_title
        starts_at: event.start
        ends_at: event.end
    success: ->
      close_dialog()
  )

delete_event = (event) ->
  $.ajax(
    type: "DELETE"
    url: "/events/#{event.id}"
    success: ->
      close_dialog()
  )

close_dialog = ->
  $('#event_dialog input#title').val("")
  $('#calendar').fullCalendar('refetchEvents')
  $('#event_dialog').dialog("close")


get_dialog_title = ->
  $('#event_dialog input#title').val()
