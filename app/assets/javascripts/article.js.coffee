show_sign_up_banner = ->
  $(window).scroll( ->
    if $(window).scrollTop() > 50
      $('.sign_up_banner').slideDown(700)
    else
      $('.sign_up_banner').slideUp(700)
  )

jQuery ->
  if $('body.articles_employee_leave_management').length || $('body.articles_employee_attendance_calendar').length || $('body.articles_business_time_tracking').length
    show_sign_up_banner()
