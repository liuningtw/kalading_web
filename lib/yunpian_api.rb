require 'restclient'

module YunpianApi
  extend self

  def send_to mobile, content
    data = {
      apikey: 'b898453f2ea218bbbe953ae0208d11dc',
      mobile: mobile,
      text: content
    }

    RestClient.post \
      "http://yunpian.com/v1/sms/send.json",
      data,
      content_type: 'json',
      accept: 'json'
  end
end