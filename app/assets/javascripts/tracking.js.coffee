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

track_sign_up = ->
  if $('.registrations_new').length
    form = $('#new_user')
    analytics.trackForm(form, 'New Account', {})

track_add_user = ->
  if $('.subscribers_show').length
    form = $('#new_user')
    analytics.trackForm(form, 'Add User', {})

track_make_manager = ->
  if $('.subscribers_show').length
    $('.js_make_manager').click ->
      analytics.track('Make employee a manager', {})

track_make_employee = ->
  if $('.subscribers_show').length
    $('js_make_employee').click ->
      analytics.track('Make manager an employee', {})

track_approve_time_off = ->
  if $('.employees_index').length
    $('.js_approve').click ->
      analytics.track('Approve Time Off', {})

track_reject_time_off = ->
  if $('.employees_index').length
    $('.js_reject').click ->
      analytics.track('Reject Time Off', {})

track_add_accrual_range = ->
  if $('.company_settings_index').length
    form = $('.accrual_form')
    analytics.trackForm(form, 'Add Accrual Range', {})

track_remove_accrual_range = ->
  if $('.company_settings_index').length
    $('.js_remove_accrual').click ->
      analytics.track('Delete Accrual Range', {})

track_delete_user = ->
  if $('.employees_show').length || $('.registrations_edit').length
    $('.js_delete_user').click ->
      analytics.track('Delete User', {})

track_add_holiday = ->
  if $('.company_settings_index').length
    form = $('.new_holiday')
    analytics.trackForm(form, 'Add Holiday', {})

track_delete_holiday = ->
  if $('.company_settings_index').length
    $('.js_remove_holiday').click ->
      analytics.track('Delete Holiday', {})

jQuery ->
  track_page_view()
  identify_user()
  group_subscriber()
  track_sign_up()
  track_add_user()
  track_make_manager()
  track_make_employee()
  track_approve_time_off()
  track_reject_time_off()
  track_add_accrual_range()
  track_remove_accrual_range()
  track_delete_user()
  track_add_holiday()
  track_delete_holiday()
