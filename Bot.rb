# module My_bot
  require_relative "Calc_query"
  require_relative "Telegram"
  require_relative "Functions"
  require_relative "app/models/reason"
  require_relative "app/models/transaction"
  include Calculate
  include My_telegram

  token = ENV["telegram_token"]

  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      #debug
      Message.new().send_text("Я что-то услышал: #{message.text}")
      begin
        Message.new().send_text("#{Reason.last.reason.to_s}")
      rescue
        Message.new().send_text("Reason does not avalible")
      end
      #/debug

      #блок обработки ошибок

      begin
          hash_message = telegram_message_parse(message.text)
          if hash_message != nil
              chat_id = message.chat.id
              case chat_id
              when 479_039_553 #alex chat
                  user_id = 2 #check database
                  reason_id = get_id_reason_after_parse(hash_message[:reason], chat_id)
                  new_transaction = Transaction.new(
                      sum: hash_message[:sum],
                      description: hash_message[:description],
                      reason: reason_id,
                      user: user_id,
                      local: true,
                      deleted: false
                  )
                  Reason.update(reason_id, often: Reason.find(reason_id).often + 1)
                  new_transaction.save

                  #send message to alex
                  Message.new(sum: hash_message[:sum], current_user: user_id, description: hash_message[:description], reason: Reason.find(reason_id).reason, enable: true).send

              when 299_454_049 #miha chat
                  user_id = 1 #check database
                  reason_id = get_id_reason_after_parse(hash_message[:reason])
                  new_transaction = Transaction.new(
                      sum: hash_message[:sum],
                      description: hash_message[:description],
                      reason: reason_id,
                      user: user_id,
                      local: true,
                      deleted: false
                  )
                  Reason.update(reason_id, often: Reason.find(reason_id).often + 1)
                  new_transaction.save

                  #send message to miha (chat_id)
                  Message.new(sum: hash_message[:sum], chat_id: chat_id, current_user: user_id, description: hash_message[:description], reason: Reason.find(reason_id).reason, enable: true).send
              else
                  Message.new().send_text("Ошибка в id чата")
              end

            else
                Message.new().send_text("Чет пустое сообщение")
            end
      rescue
        Message.new().send_text("Ошибка в основной части")
      end

    end
  end

# end
