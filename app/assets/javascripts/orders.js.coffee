#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require ./backbone/models/order.js
#= require ./backbone/views/items.js
#= require_self

$ ->

  if $(".items-select-page")
    items_view = new Kalading.Views.Items
    items_view.recoverSelectors()

  if $(".select-car-page")
    $('#car_style').chained('#car_type,#car_name')
    $('#car_type').chained('#car_name')

