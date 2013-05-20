override_datepicker = ->
  $.datepicker.setDefaults(
    changeMonth: true,
    changeYear: true,
    gotoCurrent: true
  )

jQuery ->
  if $('body.employees_show').length
    override_datepicker()


