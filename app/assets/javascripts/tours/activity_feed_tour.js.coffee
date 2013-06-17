class window.ActivityFeedTour
  constructor: ->
    @tour = new Tour()
    @step1()
    @step2()
    @step3()
    @step4()

  start: ->
    @tour.start(true)

  restart: ->
    @tour.restart()

  step1: ->
    @tour.addStep(
      path: "/activities"
      element: "#activity_feed"
      title: "Activity Feed Tour"
      content: "You will learn about how to use the activity feed to quickly view what's happening in your business."
      placement: "bottom"
    )

  step2: ->
    @tour.addStep(
      path: "/activities"
      element: ".nav-pills"
      title: "Three different Views"
      content: "There are three different ways to view activity. You can view your own activity, the activity of employees you manage (if you have any), and the activity accross your entire company."
      placement: "bottom"
    )

  step3: ->
    @tour.addStep(
      path: "/activities"
      element: "#activity_feed"
      title: "Different Types of Activity Events"
      content: "Adding new users to your account or time off request approvals will appear in green.<br/><br/>Time off request submissions, changes, and other neutral events will appear in blue.<br/><br/>Time off request rejections will appear in red to make to ensure the employee sees the rejection so that they can correct their request."
      placement: "bottom"
    )

  step4: ->
    @tour.addStep(
      path: "/activities"
      element: "#activity_feed"
      title: "Activity Feed Tour Completed!"
      content: "Congratulations! You now have the information to use the activity feed to make your business's time off request process more transparent and efficient."
      placement: "bottom"
    )
