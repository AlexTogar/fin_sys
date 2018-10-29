require 'telegram/bot'
require_relative 'app/models/family.rb'
require_relative 'app/models/user.rb'
#require 'модуль, содержащий User, Family и др'

module My_telegram
  class Message
    attr_accessor :token, :enable, :teammates, :chat_id, :current_user, :sum, :reason, :description
    def initialize(token: '649747818:AAHWX2voEkXHRzLPo0oG7VB2rhlhnrLHuFg',
       enable: false,
       teammates: [],
       chat_id: 479039553,
       current_user: ,
       sum: 0,
       reason: "",
       description: "")
       
      @token, @enable, @teammates, @chat_id, @current_user, @sum, @reason, @description =  token, enable, teammates, chat_id, current_user, sum, reason, description
    end

    def send
      if @enable
        Telegram::Bot::Client.run(@token) do |bot|
          bot.api.send_message(chat_id: @chat_id,
                               text:"Created transaction:
                                    User: #{@current_user.email}
                                    Sum: #{@sum}
                                    Reason: #{@reason}
                                    Time: #{(Time.now + 3.hour).to_s.split("+")[0]}
                                    Description: #{@description == '' ? 'Empty' : @description}"
          )
        end
      end
    end


  end

end



