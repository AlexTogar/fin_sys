require 'telegram/bot'
require_relative 'app/models/family.rb'
require_relative 'app/models/user.rb'
#require 'модуль, содержащий User, Family и др'

module My_telegram
  class Message
    attr_accessor :token, :enable, :teammates, :chat_id, :current_user, :sum, :reason, :description
    def initialize(token: '649747818:AAHWX2voEkXHRzLPo0oG7VB2rhlhnrLHuFg',
       enable: false,
       teammates: User.all.where(family: Family.find_by(user: @current_user).id) - [User.find(current_user)],
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
                               text:"Created transaction:\n
                                     User: #{@current_user.email}
                                    \nSum: #{@sum}
                                    \nReason: #{@reason}
                                    \nTime: #{(Time.now + 3.hour).to_s.split("+")[0]}
                                    \nDescription: #{@description == '' ? 'Empty' : @description}"
          )
        end
      end
    end


  end

end



