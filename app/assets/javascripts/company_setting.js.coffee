show_date_picker_for_holiday = ->
  $('#holiday_date').datepicker()


jQuery ->
  if $('body.company_settings_index').length
    show_date_picker_for_holiday()
