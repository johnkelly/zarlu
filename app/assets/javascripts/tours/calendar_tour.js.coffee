class window.CalendarTour
  constructor: ->
    @tour = new Tour()
    @step1()
    @step2()
    @step3()
    @step4()
    @step5()
    @step6()
    @step7()
    @step8()
    @step9()
    @step10()
  start: ->
    @tour.start(true)

  restart: ->
    @tour.restart()

  step1: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-button-month"
      title: "Month View"
      content: "Click on this button to view a whole month's events and time off. Use this view for scheduling all day events or viewing a month of events at a time."
      placement: "bottom"
    )

  step2: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-today"
      title: "Today's Events"
      content: "The current day is highlighted on your calendar so that you can quickly find the most relevant information."
      placement: "bottom"
    )

  step3: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-button-agendaWeek"
      title: "Week View"
      content: "Click on this button to view a whole weeks's events and time off. Use this view to schedule events in 15 minute intervals. Try clicking on it now."
      placement: "bottom"
      reflex: true
    )

  step4: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-slot40"
      title: "Schedule Time Off"
      content: "Click on a time slot and then keep your mouse pressed and drag your mouse to select how long an event lasts. Try it for yourself now!"
      placement: "bottom"
    )

  step5: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-slot40"
      title: "Lengthen or Shorten Time Off"
      content: "Click on the bottom center of a scheduled time off event (You should see two horizontal lines) and then drag your mouse to change the time of an event."
      placement: "bottom"
    )

  step6: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-slot40"
      title: "Move Time Off"
      content: "Click in the center of a scheduled time off event and then drag your mouse to a different time or day to move an event."
      placement: "bottom"
    )

  step7: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-slot40"
      title: "Rename or Delete Time Off"
      content: "Double click on a time off event to bring up a popup to delete a time off event or rename it."
      placement: "bottom"
    )

  step8: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-button-agendaDay"
      title: "Day View"
      content: "Click on this button to view a day's events and time off. Use this view to schedule events in 15 minute intervals. Try clicking on it now."
      placement: "bottom"
    )

  step9: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-button-prev"
      title: "Change Months, Weeks, or Days"
      content: "Click on the arrows to change the month, week, or day that you are viewing."
      placement: "bottom"
    )

  step10: ->
    @tour.addStep(
      path: "/home"
      element: ".fc-header-title"
      title: "Congratulations you mastered the calendar!"
      content: "You have completed the calendar tour! Remember time off changes on your calendar are sent directly to your manager. It's that easy!"
      placement: "bottom"
    )
