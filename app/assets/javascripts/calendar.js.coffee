user_calendar = ->
  $('#user_calendar').fullCalendar
    header:
      left: 'month, agendaWeek, agendaDay'
      center: 'title'
    height: 700
    editable: true
    selectable: true
    slotMinutes: 15
    eventSources:
      [
        {
          url: '/events'
          color: '#0668C0'
          textColor: '#FFF'
          ignoreTimezone: false
        },
        {
          url: '/holidays'
          color: '#0668C0'
          textColor: '#FFF'
          ignoreTimezone: false
          editable: false
        }
      ]
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      update_move_event(event)
    eventResize: (event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view) ->
      update_move_event(event)
    eventClick: (event, jsEvent, view) ->
      unless is_holiday(event)
        show_edit_event_dialog(event, jsEvent, view)
    select: (startDate, endDate, allDay, jsEvent, view) ->
      show_add_event_dialog(startDate, endDate, allDay, jsEvent, view)
    eventRender: (event, element) ->
      unless event.approved
        add_stripe_to_pending_event(element)
      true


manager_calendar = ->
  $('#manager_calendar').fullCalendar
    header:
      left: 'month, agendaWeek, agendaDay'
      center: 'title'
    height: 700
    editable: true
    selectable: true
    slotMinutes: 15
    eventSources:
      [
        {
          url: '/events/manager'
          color: '#0668C0'
          textColor: '#FFF'
          ignoreTimezone: false
        },
        {
          url: '/holidays'
          color: '#0668C0'
          textColor: '#FFF'
          ignoreTimezone: false
          editable: false
        }
      ]
    eventRender: (event, element) ->
      unless event.approved
        add_stripe_to_pending_event(element)
      true

company_calendar = ->
  $('#company_calendar').fullCalendar
    header:
      left: 'month, agendaWeek, agendaDay'
      center: 'title'
    height: 700
    editable: true
    selectable: true
    slotMinutes: 15
    eventSources:
      [
        {
          url: '/events/company'
          color: '#0668C0'
          textColor: '#FFF'
          ignoreTimezone: false
        },
        {
          url: '/holidays'
          color: '#0668C0'
          textColor: '#FFF'
          ignoreTimezone: false
          editable: false
        }
      ]
    eventRender: (event, element) ->
      unless event.approved
        add_stripe_to_pending_event(element)
      true

show_available_hours_for_kind_of_time_off = ->
  $('#event_kind').change( ->
    get_available_hours(@value)
  )

get_default_available_hours = ->
  default_value = $('#event_kind').val()
  get_available_hours(default_value)

jQuery ->
  if $('body.homes_show').length
    if $('#user_calendar').length
      user_calendar()
      get_default_available_hours()
      show_available_hours_for_kind_of_time_off()
    else if $('#manager_calendar').length
      manager_calendar()
    else if $('#company_calendar').length
      company_calendar()

show_add_event_dialog = (startDate, endDate, allDay, jsEvent, view) ->
  add_one_minute_to_endDate_for_allDay_events(endDate) if allDay
  $('#event_dialog').dialog(
    modal: true
    title: "New Event on #{format_dialog_title_date(startDate)}"
    open: ->
      press_enter_to_save()
      show_selected_hours_on_dialog(startDate, endDate, allDay)
    close: unbind_press_enter_to_save
    buttons:
      [
        text: "Save"
        click: ->
          create_event(get_dialog_title(), startDate, endDate, allDay, jsEvent, view, get_dialog_kind())
      ]
  )

show_edit_event_dialog = (event, jsEvent, view) ->
  display_correct_event_type_in_dropdown(event.color)
  $('#event_dialog').dialog(
    modal: true
    title: "Edit Event on #{format_dialog_title_date(event.start)}"
    open: ->
      press_enter_to_save()
      show_selected_hours_on_dialog(event.start, event.end, event.allDay)
    close: unbind_press_enter_to_save
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

create_event = (title, startDate, endDate, allDay, jsEvent, view, kind) ->
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
        kind: kind
    success: ->
      close_dialog()
      get_default_available_hours()
      track_create_event()
  )

update_event = (event) ->
  event_title = get_dialog_title()
  event_kind = get_dialog_kind()
  new_title = if !!event_title then event_title else event.title
  new_kind = if !!event_kind then event_kind else event.kind
  $.ajax(
    type: "PUT"
    url: "/events/#{event.id}"
    data:
      event:
        title: new_title
        starts_at: event.start
        ends_at: event.end
        kind: new_kind
    success: ->
      close_dialog()
      get_default_available_hours()
      track_update_event()
  )

update_move_event = (event) ->
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
      get_default_available_hours()
      track_move_event()
  )

delete_event = (event) ->
  $.ajax(
    type: "DELETE"
    url: "/events/#{event.id}"
    success: ->
      close_dialog()
      get_default_available_hours()
      track_delete_event()
  )

get_available_hours = (event_type) ->
  $.ajax(
    type: "GET"
    url: "/leaves"
    data:
      kind: event_type
    success: (leave) ->
      $('#available_hours').text("#{available_hours(leave)} hours")
      $('#pending_hours').text("#{leave.pending_hours} hours")
  )

show_selected_hours_on_dialog = (startDate, endDate, allDay) ->
  $('#selected_hours').text("#{selected_hours(startDate, endDate, allDay)} hours")

close_dialog = ->
  $('#event_dialog input#title').val("")
  $('.calendar').fullCalendar('refetchEvents')
  $('#event_dialog').dialog("close")


get_dialog_title = ->
  $('#event_dialog input#title').val()

get_dialog_kind = ->
  $('#event_dialog #event_kind').val()

press_enter_to_save = ->
  $('#dialog_form').keypress (e) ->
    if e.keyCode is $.ui.keyCode.ENTER
      e.preventDefault()
      $("button:contains('Save')").trigger("click")

unbind_press_enter_to_save = ->
  $('#dialog_form').unbind("keypress")

format_dialog_title_date = (event_date) ->
  event_date.toString().split(todays_year())[0]

todays_year = ->
  new Date().getFullYear()

available_hours = (leave) ->
  leave.accrued_hours - leave.used_hours

selected_hours = (startDate, endDate, allDay) ->
  if allDay
    Math.round(8.0 * number_of_days(startDate, endDate))
  else
    number_of_hours(startDate, endDate)

add_stripe_to_pending_event = (element) ->
  element.find('.fc-event-inner').addClass("pending_event")

number_of_days = (startDate, endDate) ->
  ((endDate - startDate) / 86400000) + 1

number_of_hours = (startDate, endDate) ->
  (endDate - startDate) / 3600000

add_one_minute_to_endDate_for_allDay_events = (endDate) ->
  endDate.setTime(endDate.getTime() + 1000 * 60)

display_correct_event_type_in_dropdown = (color) ->
  $('#event_kind').val(event_type(color)).change()

event_type = (color) ->
  switch color
    when "#0668C0" then "0"
    when "green" then "1"
    when "#FF5E00" then "2"
    when "purple" then "3"
    when "red" then "4"
    when "black" then "5"

is_holiday = (event) ->
  event.color == "#FF5E00"

track_create_event = ->
  analytics.track('Create Time Off Request', {})

track_update_event = ->
  analytics.track('Update Time Off Request', {})

track_move_event = ->
  analytics.track('Move Time Off Request', {})

track_delete_event = ->
  analytics.track('Delete Time Off Request', {})

