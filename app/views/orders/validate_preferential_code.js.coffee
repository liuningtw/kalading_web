<% if @result['discount']['error'] %>
  alert '优惠券错误'

  type = $("#service_type").val()
  car_id = $("#car_id").val()
  parts = $('#item_table').data("parts")
  $.post "/orders/no_preferential", { car_id: car_id, parts: parts, type: type }
<% else %>
  $("#item_table").closest('.section').replaceWith $("<%= escape_javascript(render('offer_table')) %>")
  $(".new-offer-table").replaceWith $("<%= escape_javascript(render('new_offer_table')) %>")
  $("#final_price").text("<%= @result['price'] %>")
  $("#result_price").text("<%= @result['price'] %>")
  $("#preferential_code").prop "readonly", true
  $("#validate_preferential").addClass('hidden')
  $("#no_preferential").removeClass('hidden')
<% end %>
