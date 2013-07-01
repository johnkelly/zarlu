track_page_view = ->
  analytics.pageview()

identify_user = ->
  if $('#segment_io_user_data').length
    user = $('#segment_io_user_data').data()

    analytics.identify(user.id, {
      email: user.email
      name:  user.name
    })

group_subscriber = ->
  if $('#segment_io_subscriber_data').length
    subscriber = $('#segment_io_subscriber_data').data()

    analytics.group(subscriber.id, {
      name: subscriber.name,
      trial: subscriber.trial,
      card: subscriber.card,
      users: subscriber.users,
      monthly_revenue: (subscriber.users * 5),
    })


jQuery ->
  track_page_view()
  identify_user()
  group_subscriber()
