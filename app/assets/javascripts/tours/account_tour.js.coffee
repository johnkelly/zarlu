class window.AccountTour
  constructor: ->
    @tour = new Tour()
    @step1()
    @step2()
    @step3()
    @step4()
    @step5()
    @step6()
    @step7()

  start: ->
    @tour.start(true)

  restart: ->
    @tour.restart()

  step1: ->
    @tour.addStep(
      path: "/subscribers"
      element: "#navbar_manage_dropdown"
      title: "Account Management Tour"
      content: "This tour will teach you how to add employees to your account and group them by schedule manager."
      placement: "bottom"
    )

  step2: ->
    @tour.addStep(
      path: "/subscribers"
      element: "#new_user"
      title: "Add Employees"
      content: "This form allows you to quickly add your employees to your account. Enter their email and a temporary password. Your employee will then be to sign in."
      placement: "right"
    )

  step3: ->
    @tour.addStep(
      path: "/subscribers"
      element: "th:contains('Schedule Manager')"
      title: "Change Schedule Manager"
      content: "You can assign a schedule manager to approve or reject an employee's time-off by clicking the edit icon and selecting a manger."
      placement: "top"
    )

  step4: ->
    @tour.addStep(
      path: "/subscribers"
      element: "th:contains('Personal')"
      title: "View Employee Time-Off"
      content: "View the amount of time-off an employee has used divided by category."
      placement: "top"
    )

  step5: ->
    @tour.addStep(
      path: "/subscribers"
      element: ".btn-mini:contains('Make Manager'):first"
      title: "Make Employee a Manager"
      content: "When you click on make manager, you will make the employee a manager who can oversee other employees' time off requests."
      placement: "right"
    )

  step6: ->
    @tour.addStep(
      path: "/subscribers"
      element: ".btn-mini:contains('Make Employee'):first"
      title: "Make Manager an Employee"
      content: "If an employee's responsibilities have changed, you can remove manager permissions by clicking on the make employee button."
      placement: "right"
    )

  step7: ->
    @tour.addStep(
      path: "/subscribers"
      element: "#navbar_manage_dropdown"
      title: "Congratulations! You mastered the account page."
      content: "You now know how to add employees to your account and group them by the manager who will approve or reject their time off requests."
      placement: "bottom"
    )
