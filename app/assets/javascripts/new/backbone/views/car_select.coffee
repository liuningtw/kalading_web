class App.Views.CarSelect extends Backbone.View

  el: '.first'

  events:
    "click ul.crumbs > li":      "selectBrandByLetter"
    "click ul.crumbs > li > a":  "triggerByLetter"
    "click ul.brand-list > li":  "viewBrandName"
    "click ul.series-list > li": "viewSubModelName"
    "click ul.model-list > li":  "selectModel"

  initialize: ->
    unless $.jStorage.get("autos")?
      $.get ("#{API_Domain}#{V2}/autos.json"), (data)->
        console.log("load autos data")
        $.jStorage.set("autos", data['data'], {TTL: 1000*60*60*24*10}) #本地存储
        generateCarIndex($.jStorage.get("autos"))
    else
      generateCarIndex($.jStorage.get("autos"))

  render: ->

  selectModel: (e)=>
    self = $(e.target)
    car_id = self.data("car_id")
    @$(".next").find("a").attr("car_id", car_id)

  selectBrandByLetter: (e)=>
    self = $(e.target)
    self.find("a").trigger("click")

  triggerByLetter: (e)=>
    $(".brand-list").html("")
    self = $(e.target)
    letter = self.html()
    ele = self.parent("li")
    ele.addClass('active').siblings().removeClass('active')
    generateCarBrand(letter)

  viewSubModelName: (e)=>
    self = $(e.currentTarget)
    model_id = self.data('model_id')

    $.ajax({
      method: "GET",
      url : "#{API_Domain}#{V2}/auto_models/#{model_id}.json",
      beforeSend: ->
        $('.tips').removeClass('hide')
      ,
      complete: ->
        $('.tips').addClass('hide')
      ,
      success: (data)->
        submodels = data['data']
        generateCarSubModel(submodels)
    })

  viewBrandName: (e)=>
    self = $(e.currentTarget)
    brand_name = self.text()
    letter = self.data('letter')
    brname = self.find("span").html()
    $('.selected-name').removeClass('hide').find('.name').text(brand_name)
    #选择车系标签
    $('.select-series').addClass('active')
    #显示选择车系 隐藏选择品牌
    $('.first .maintain-items .items').eq(0).addClass('hide').next().removeClass('hide')

    generateCarModel(letter, brname)

  generateCarSubModel = (submodels)-> #生成子品牌
    $("ul.model-list").html("")
    _.each submodels, (submodel)->
      _.each submodel['submodels'], (sub)->
        $("ul.model-list").append("<li data-car_id=#{sub['id']} class='cursor'>#{sub['year_range']} - #{sub['engine_displacement']}</li>")

  generateCarModel = (letter, brname)-> #生成车系
    brands = $.jStorage.get("auto-#{letter}")
    brand = _.where(brands, {name: brname})
    auto_models = brand[0]['auto_models']
    $("ul.series-list").html("")

    _.each auto_models, (model)->
      $("ul.series-list").append("<li data-model_id='#{model['id']}' class='cursor'>#{model['name']}</li>")

  generateCarBrand = (letter) -> #生成品牌
    brands = $.jStorage.get("auto-#{letter}")
    _.each brands, (brand)->
      str = "<li data-letter=#{letter} class='cursor'><img src='#{brand['logo']}'/> <span>#{brand['name']}</span></li>"
      $("ul.brand-list").append(str)

  generateCarIndex = (autos)-> #生成索引
    _.each autos, (auto)->
      $.jStorage.set("auto-#{auto['initial']}", auto['autos']) #将单条 数据存储
      $("ul.crumbs").append("<li class='cursor'><a href='javascript:;'>#{auto['initial']}</a></li>")
