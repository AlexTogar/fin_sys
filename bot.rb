require 'telegram/bot'
token = "649747818:AAHWX2voEkXHRzLPo0oG7VB2rhlhnrLHuFg"

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    when '/info'
      bot.api.send_message(chat_id: message.chat.id, text: "INFO:\nChat id: #{message.chat.id}\nTime: #{Date.today}\nYour text: #{message.text}")
    when '/commands'
      bot.api.send_message(chat_id: message.chat.id, text: "Commands:\n/start\n/stop\n/info\n/commands")
    else
      bot.api.send_message(chat_id: message.chat.id, text: "Don't understand, but you can use command /commands")
    end

  end
end
