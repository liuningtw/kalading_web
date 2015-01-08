class OrdersController < ApplicationController

  def select_car
    type = params[:type]
    @cars_info = Order.cars_data type
    @result = Order.items_for params[:car_id]
  end

  def refresh_price
    car_id = params["order"]["car_id"]
    parts = params["order"]["parts"].try :values
    payload = {
      "parts" => parts
    }
    result = Order.refresh_price car_id, payload
    render json: { result: result }
  end

  def select_item
    @result = Order.items_for params[:car_id]
  end

  def place_order
    # car_id = params["order"]["car_id"]
    # parts = params["order"]["parts"]
    # payload = {
    #   "parts" => parts
    # }

    #@result = Order.refresh_price car_id, payload
  end

  def submit

    car_id = params["car_id"]
    type = params["type"]
    parts = params["parts"]


    # json_data = '
    #   "parts": [
    #     {
    #       "brand": "曼牌 Mann",
    #       "number": "528af433098e7180590042ca"
    #     },
    #     {
    #       "brand": "卡拉丁",
    #       "number": "53672bab9a94e45d440005ae"
    #     }
    #   ],
    #   "info": {
    #     "address": "北京朝阳区光华路888号",
    #     "name": "王一迅",
    #     "phone_num": "13888888888",
    #     "client_id": "040471abcd",
    #     "car_location": "京",
    #     "car_num": "N333M3",
    #     "serve_datetime": "2014-06-09 15:44",
    #     "pay_type": 1,
    #     "reciept_type": 1,
    #     "reciept_title": "卡拉丁汽车技术",
    #     "client_comment": "请按时到场",
    #     "city_id": "5307033e098e719c45000043"
    #   }
    # }
    # '


    payload = JSON.parse json_data
    Order.submit car_id, payload
  end

  def show
  end

  def order_status
  end


end
