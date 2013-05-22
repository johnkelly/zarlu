class window.EmployeeWelcomeTour
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
      path: "/employee-welcome"
      element: ".navbar"
      title: "Welcome to Zarlu!"
      content: "You will learn how to navigate Zarlu with this quick tour."
      placement: "bottom"
    )

  step2: ->
    @tour.addStep(
      path: "/employee-welcome"
      element: "#start_tour"
      title: "Tour Button"
      content: "Every page of your account comes with its own custom tour to get you familiar with Zarlu.<br/><br/>Just navigate to the page you want to learn more about and click on the green button in the nav bar to begin a tour."
      placement: "bottom"
    )

  step3: ->
    @tour.addStep(
      path: "/employee-welcome"
      element: "#navbar_settings_dropdown"
      title: "Settings"
      content: "The settings link is a dropdown that gives you access to several key pages for managing your subscription.<br/><br/><strong>Change / View Billing Info</strong> is where you add or change your company's credit card information or view your company's current subscription's information.<br/><br/><strong>Change Email / Pass Phrase</strong> is where you go to change your email, name, password, avatar, or delete your account.<br/><br/><strong>Sign Out</strong> is where you click when you want to exit Zarlu."
      placement: "bottom"
    )

  step4: ->
    @tour.addStep(
      path: "/employee-welcome"
      element: "#navbar_contact_us"
      title: "Customer Support"
      content: "Every page has a link to Contact Us where you can quickly submit a support request, feedback, or just say Hello!<br/><br/>All support request are sent directly to our engineers so that we can solve your issue as quickly as possible. We try our best to solve all requests within 24 hours or less."
      placement: "bottom"
    )

  step5: ->
    @tour.addStep(
      path: "/employee-welcome"
      element: "#navbar_activity_feed"
      title: "Activity Feed"
      content: "What have I done on Zarlu? Was my time off request successfully submitted? Did my manager approve or reject my time off request?<br/><br/>The activity feed answers all those questions and more. View all activity on your Zarlu account: new time off requests, approvals, rejections, and modifications to exisiting time off."
      placement: "bottom"
    )

  step6: ->
    @tour.addStep(
      path: "/employee-welcome"
      element: "#navbar_calendar"
      title: "Calendar"
      content: "<strong>The calendar is where you submit time off and schedule changes and view your schedule.</strong><br/><br/>The calendar gives you access to add new time off, change time off dates/times, cancel time off, view your schedule for the month, week, day, and much more!"
      placement: "bottom"
    )

  step7: ->
    @tour.addStep(
      path: "/employee-welcome"
      element: "#navbar_employee_welcome"
      title: "Congratulations!"
      content: "You have completed the welcome tour! You now know how to navigate Zarlu to find the features you need to submit time off. If you still have questions, do not hesitate to contact us."
      placement: "bottom"
    )
