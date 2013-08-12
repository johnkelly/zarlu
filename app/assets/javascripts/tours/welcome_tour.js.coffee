class window.WelcomeTour
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

  start: ->
    @tour.start(true)

  restart: ->
    @tour.restart()

  step1: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: ".navbar"
      title: "Welcome to Zarlu!"
      content: "You will learn how to navigate Zarlu with this quick tour."
      placement: "bottom"
    )

  step2: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: "#start_tour"
      title: "Tour Button"
      content: "Every page of your account comes with its own custom tour to get you and your employees familiar with Zarlu.<br/><br/>Just navigate to the page you want to learn more about and click on the green button in the nav bar to begin a tour."
      placement: "bottom"
    )

  step3: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: "#navbar_settings_dropdown"
      title: "Settings"
      content: "The settings link is a dropdown that gives you access to several key pages for managing your subscription.<br/><br/><strong>Change / View Billing Info</strong> is where you add or change your credit card information or view your current subscription's information.<br/><br/><strong>Change Email / Pass Phrase</strong> is where you go to change your email, pass phrase, or delete your account.<br/><br/><strong>Sign Out</strong> is where you click when you want to exit Zarlu."
      placement: "bottom"
    )

  step4: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: "#navbar_contact_us"
      title: "Customer Support"
      content: "Every page has a link to Contact Us where you can quickly submit a support request, feedback, or just say Hello!<br/><br/>All support request are sent directly to our engineers so that we can solve your issue as quickly as possible. We try our best to solve all requests within 24 hours or less."
      placement: "bottom"
    )

  step5: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: "#navbar_activity_feed"
      title: "Activity Feed"
      content: "What have I done on Zarlu? If I manage employees, what time off changes have my employees made? What employee scheduling changes have been made throughout my business?<br/><br/>The activity feed answers all those questions for your business. View all activity on your Zarlu account: new users, new time off requests, approvals, rejections, modifications to exisiting time off, and more!"
      placement: "bottom"
    )

  step6: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: "#navbar_calendar"
      title: "Calendar"
      content: "<strong>The calendar is where you submit time off and schedule changes.</strong> Each of your employees is given access to their own calendar where they submit time off requests and view their schedule.<br/><br/>The calendar gives you access to add new time off, change time off dates/times, cancel time off, view your schedule for the month, week, day, and much more!"
      placement: "bottom"
    )

  step7: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: "#navbar_manage_dropdown"
      title: "Manage Pages"
      content: "<strong>The time off request page is where a manager approves or rejects time off and schedule changes.</strong> Employees who have a manager will have time off requests go to their manager's employee tab for their manager's approval.<br/><br/><strong>The employee page is where a manager adds and groups employees.</strong> Assign new managers, add co-workers to your account, and group employees by the manager who will approve their schedule changes."
      placement: "bottom"
    )

  step8: ->
    @tour.addStep(
      path: "/manager/setup-complete"
      element: "#navbar_welcome"
      title: "Congratulations!"
      content: "You have completed the welcome tour! You now know how to navigate Zarlu to find the features you need to manage employee time off. If you still have questions, do not hesitate to contact us."
      placement: "bottom"
    )
