module Calculate

  require 'nokogiri'
  require 'net/http'
  require 'open-uri'
  require 'uri'
  require 'json'

  class Calc_query
    attr_accessor :appid, :input, :yandex_key

    def initialize(appid: 'HP44EW-XHHUV3698T', key: 'trnsl.1.1.20181019T100255Z.a1f5945c9e725938.33d1d873f6a0cb522f363ba06133bf8f0c32e678', input: '2+2')
      @appid = appid
      @yandex_key = key
      @input = input
    end

    def translate
      @input = URI.encode(@input)
      url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{@yandex_key}&text=#{@input}&lang=ru-en"
      response = Net::HTTP.get_response(URI.parse(url))
      json_response = JSON.parse(response.body)
      json_response['text'][0]
    end

    def send

      if @input.gsub(/[0-9]*/, "") != ""

        if @input.gsub(/[а-я]*/, "").size != @input.size
          @input = translate
          url = "http://api.wolframalpha.com/v2/query?input=#{@input}&appid=#{@appid}"
          response = Nokogiri::HTML(open(url)).search('plaintext')[1].content
        else
          url = "http://api.wolframalpha.com/v2/query?input=#{@input}&appid=#{@appid}"
          response = Nokogiri::HTML(open(url)).search('plaintext')[2].content
        end
        begin
          response = response.to_i
        rescue
          return 0
        end
      else
        @input.to_i
      end

    end
  end

end