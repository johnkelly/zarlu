class window.AccountTour
  constructor: ->
    @tour = new Tour()
    @step1()
    @step2()
    @step3()
    @step4()
    @step5()

  start: ->
    @tour.start(true)

  restart: ->
    @tour.restart()

  step1: ->
    @tour.addStep(
      path: "/subscribers"
      element: ".paper"
      title: "Account Management Tour"
      content: "This tour will teach you how to add employees to your account and group them by manager."
      placement: "left"
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
      element: ".btn-mini"
      title: "Make Employee a Manager"
      content: "Click on this button to make the employee a manager who will oversee other employees' time off requests."
      placement: "right"
      reflex: true
    )

  step4: ->
    @tour.addStep(
      path: "/subscribers"
      element: "ul.sortable"
      title: "Group Employees by Manager"
      content: "Click on the employee highlighted in blue and keep your mouse pressed while you drag the blue tag to the right underneath the manager who will oversee their time off requests."
      placement: "top"
    )

  step5: ->
    @tour.addStep(
      path: "/subscribers"
      element: "h2"
      title: "Congratulations! You mastered the account page."
      content: "You now know how to add employees to your account and group them by the manager who will approve or reject their time off requests."
      placement: "bottom"
    )