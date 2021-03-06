# encoding: utf-8
# 1, @weixin_message: 获取微信所有参数.
# 2, @weixin_public_account: 如果配置了public_account_class选项,则会返回当前实例,否则返回nil.
# 3, @keyword: 目前微信只有这三种情况存在关键字: 文本消息, 事件推送, 接收语音识别结果
WeixinRailsMiddleware::WeixinController.class_eval do

  def reply
    render xml: send("response_#{@weixin_message.MsgType}_message", {})
  end

  private

    def handle_recv_messages msg
      account = PublicAccount.find_by(account_id: msg.ToUserName)
      message = account.recv_messages.new
      message.set_info msg
      message.save
    end

    def auto_response(keyword, account_id)

      # auto_reply_msg 是默认自动回复的信息， 消息类型:text
      # follow_reply_msg 是关注后自动回复的信息，消息类型:text
      account = PublicAccount.find_by(account_id: account_id)
      reply_msg = account.reply_messages.find_by(keyword: keyword)

      if reply_msg
        case reply_msg.msg_type
        when "text"
          reply_text_message(reply_msg.reply_message)
        when "news"
          reply_news_message(generate_news(reply_msg.reply_message))
        end
      else
        if Time.now.hour.in?(8..20)
          reply_transfer_customer_service_message
        else
          msg = account.reply_message.find_by(keyword: "auto_reply_msg")
          reply_text_message(msg.reply_message)
        end
      end
    end

    def generate_news(articles)
      news = Array.new
      articles.each do |article|
        pic_url = Settings.domain + article.pic.url
        news.push(generate_article(article.title, article.description, pic_url, article.url))
      end
      news
    end

    def response_text_message(options={})
      handle_recv_messages @weixin_message
      auto_response(@keyword, @weixin_message.ToUserName)
    end

    # <Location_X>23.134521</Location_X>
    # <Location_Y>113.358803</Location_Y>
    # <Scale>20</Scale>
    # <Label><![CDATA[位置信息]]></Label>
    def response_location_message(options={})
      @lx    = @weixin_message.Location_X
      @ly    = @weixin_message.Location_Y
      @scale = @weixin_message.Scale
      @label = @weixin_message.Label
      handle_recv_messages @weixin_message
      reply_transfer_customer_service_message
      #reply_text_message("Your Location: #{@lx}, #{@ly}, #{@scale}, #{@label}")
    end

    # <PicUrl><![CDATA[this is a url]]></PicUrl>
    # <MediaId><![CDATA[media_id]]></MediaId>
    def response_image_message(options={})
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      @pic_url  = @weixin_message.PicUrl  # 也可以直接通过此链接下载图片, 建议使用carrierwave.
      handle_recv_messages @weixin_message
      auto_response(@keyword, @weixin_message.ToUserName)
      # reply_image_message(generate_image(@media_id))
    end

    # <Title><![CDATA[公众平台官网链接]]></Title>
    # <Description><![CDATA[公众平台官网链接]]></Description>
    # <Url><![CDATA[url]]></Url>
    def response_link_message(options={})
    # @title = @weixin_message.Title
    # @desc  = @weixin_message.Description
    # @url   = @weixin_message.Url
      handle_recv_messages @weixin_message
      auto_response(@keyword, @weixin_message.ToUserName)
      # reply_text_message("回复链接信息")
    end

    # <MediaId><![CDATA[media_id]]></MediaId>
    # <Format><![CDATA[Format]]></Format>
    def response_voice_message(options={})
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      @format   = @weixin_message.Format
      # 如果开启了语音翻译功能，@keyword则为翻译的结果
      auto_response(@keyword, @weixin_message.ToUserName)
    end

    # <MediaId><![CDATA[media_id]]></MediaId>
    # <ThumbMediaId><![CDATA[thumb_media_id]]></ThumbMediaId>
    def response_video_message(options={})
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      # 视频消息缩略图的媒体id，可以调用多媒体文件下载接口拉取数据。
      @thumb_media_id = @weixin_message.ThumbMediaId
      auto_response(@keyword, @weixin_message.ToUserName)
      # reply_text_message("回复视频信息")
    end

    def response_event_message(options={})
      event_type = @weixin_message.Event
      send("handle_#{event_type.downcase}_event")
    end

    private

      # 关注公众账号
      def handle_subscribe_event
        account = PublicAccount.find_by(account_id:@weixin_message.ToUserName)
        account.auth_infos.create(provider:"weixin",
                                  uid:@weixin_message.FromUserName)

        auto_response("follow_reply_msg", @weixin_message.ToUserName)
      end

      # 取消关注
      def handle_unsubscribe_event
        account = PublicAccount.find_by(account_id:@weixin_message.ToUserName)
        auth_info = account.auth_infos.find_by(provider:"weixin",
                                                    uid:@weixin_message.FromUserName)
        if user_authinfo = UserAuthinfo.find_by(auth_info_id:auth_info.id)
          user_authinfo.delete
        end
        Rails.logger.info("欢迎再来！#{@weixin_message.FromUserName}").to_s
      end

      # 扫描带参数二维码事件: 2. 用户已关注时的事件推送
      def handle_scan_event
        reply_text_message(auto_msg)
        # reply_text_message("扫描带参数二维码事件: 2. 用户已关注时的事件推送, keyword: #{@keyword}")
      end

      def handle_location_event # 上报地理位置事件
        @lat = @weixin_message.Latitude
        @lgt = @weixin_message.Longitude
        @precision = @weixin_message.Precision
        reply_text_message("Your Location: #{@lat}, #{@lgt}, #{@precision}")
      end

      # 点击菜单拉取消息时的事件推送
      def handle_click_event
        auto_response(@keyword, @weixin_message.ToUserName)
      end

      # 点击菜单跳转链接时的事件推送
      def handle_view_event
        Rails.logger.info("你点击了: #{@keyword}")
      end

      # 帮助文档: https://github.com/lanrion/weixin_authorize/issues/22

      # 由于群发任务提交后，群发任务可能在一定时间后才完成，因此，群发接口调用时，仅会给出群发任务是否提交成功的提示，若群发任务提交成功，则在群发任务结束时，会向开发者在公众平台填写的开发者URL（callback URL）推送事件。

      # 推送的XML结构如下（发送成功时）：

      # <xml>
      # <ToUserName><![CDATA[gh_3e8adccde292]]></ToUserName>
      # <FromUserName><![CDATA[oR5Gjjl_eiZoUpGozMo7dbBJ362A]]></FromUserName>
      # <CreateTime>1394524295</CreateTime>
      # <MsgType><![CDATA[event]]></MsgType>
      # <Event><![CDATA[MASSSENDJOBFINISH]]></Event>
      # <MsgID>1988</MsgID>
      # <Status><![CDATA[sendsuccess]]></Status>
      # <TotalCount>100</TotalCount>
      # <FilterCount>80</FilterCount>
      # <SentCount>75</SentCount>
      # <ErrorCount>5</ErrorCount>
      # </xml>
      def handle_masssendjobfinish_event
        Rails.logger.info("回调事件处理")
      end

end
