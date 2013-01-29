drag_and_drop_lists = ->
  $('.sortable').sortable(
    connectWith: ".sortable"
    placeholder: "alert alert-info height_25"
    receive: (event, ui) ->
      _save_manager_for_employee(ui.item, this)
  ).disableSelection()

jQuery ->
  if $('body.subscribers_show').length
    drag_and_drop_lists()

$(document).bind('page:change', ->
  if $('body.subscribers_show').length
    drag_and_drop_lists()
)

_save_manager_for_employee = (li, ul) ->
  user_id = $(li).data('user_id')
  manager_id = $(ul).data('manager_id')

  $.ajax(
    url: "/subscribers/change_manager"
    type: "PUT"
    data:
      user_id: user_id
      manager_id: manager_id
  )
