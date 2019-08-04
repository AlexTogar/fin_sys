# frozen_string_literal: true
module My_telegram
require 'telegram/bot'
# require_relative 'app/models/family.rb'
# require_relative 'app/models/user.rb'
# require 'модуль, содержащий User, Family и др'


  #класс для расслыки сообщений о совершении транзакций
  class Message
    attr_accessor :token, :enable, :teammates, :chat_id, :current_user, :sum, :reason, :description
    def initialize(token: ENV["telegram_token"],
                   enable: false,
                   teammates: [],
                   chat_id: 479_039_553,
                   current_user:User.find(2),
                   sum: 0,
                   reason: '',
                   description: '')

      @token = token
      @enable = enable
      @teammates = teammates
      @chat_id = chat_id
      @current_user = current_user
      @sum = sum
      @reason = reason
      @description = description
    end

    def send
      if @enable
        Telegram::Bot::Client.run(@token) do |bot|
          bot.api.send_message(chat_id: @chat_id,
                               text: "Created transaction:
User: #{@current_user.email}
Sum: #{@sum}
Reason: #{@reason}
Description: #{@description == '' ? 'Empty' : @description}")
        end
      end
    end

    def send_error_message
      Telegram::Bot::Client.run(@token) do |bot|
        bot.api.send_message(chat_id: @chat_id, text: "Error")
      end
    end

    def send_text(text)
      Telegram::Bot::Client.run(@token) do |bot|
        bot.api.send_message(chat_id: @chat_id, text: text)
      end
    end


  end
end
