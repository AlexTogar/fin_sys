module My_bot
  require_relative "Calc_query"
  require_relative "Telegram"
  require_relative 'app/models/reason.rb'
  require_relative 'app/models/transaction.rb'

  include Calculate
  include My_telegram


  #==========================================#точно работающий код - начало#==========================================#

  # token = ENV["telegram_token"]

  # Telegram::Bot::Client.run(token) do |bot|
  #   bot.listen do |message|
  #     case message.text
  #     when '/start'
  #       bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
  #     when '/stop'
  #       bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
  #     when '/info'
  #       bot.api.send_message(chat_id: message.chat.id, text: "INFO:\nChat id: #{message.chat.id}\nTime: #{Date.today}\nYour text: #{message.text}")
  #     when '/commands'
  #       bot.api.send_message(chat_id: message.chat.id, text: "Commands:\n/start\n/stop\n/info\n/commands")
  #     else
  #       bot.api.send_message(chat_id: message.chat.id, text: "Don't understand, but you can use command /commands")
  #     end

  #   end
  # end


  #==========================================#точно работающий код - конец#==========================================#



  token = ENV["telegram_token"]

  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      #debug
      Message.new().send_text("Я что-то услышал: #{message.text}")
      bot.api.send_message(chat_id: message.chat.id, text: "hello, #{message.from.first_name}")
      #/debug

      #блок обработки ошибок (чтобы не ломался)

      # begin
      #     hash_message = telegram_message_parse(message.text)
      #     if hash_message != nil
      #         chat_id = message.chat.id
      #         case chat_id
      #         when 479_039_553 #alex chat
      #             user_id = 2 #check database
      #             reason_id = get_id_reason_after_parse(hash_message[:reason], chat_id)
      #             new_transaction = Transaction.new(
      #                 sum: hash_message[:sum],
      #                 description: hash_message[:description],
      #                 reason: reason_id,
      #                 user: user_id,
      #                 local: true,
      #                 deleted: false
      #             )
      #             Reason.update(reason_id, often: Reason.find(reason_id).often + 1)
      #             new_transaction.save

      #             #send message to alex
      #             Message.new(sum: hash_message[:sum], current_user: user_id, description: hash_message[:description], reason: Reason.find(reason_id).reason, enable: true).send

      #         when 299_454_049 #miha chat
      #             user_id = 1 #check database
      #             reason_id = get_id_reason_after_parse(hash_message[:reason])
      #             new_transaction = Transaction.new(
      #                 sum: hash_message[:sum],
      #                 description: hash_message[:description],
      #                 reason: reason_id,
      #                 user: user_id,
      #                 local: true,
      #                 deleted: false
      #             )
      #             Reason.update(reason_id, often: Reason.find(reason_id).often + 1)
      #             new_transaction.save

      #             #send message to miha (chat_id)
      #             Message.new(sum: hash_message[:sum], chat_id: chat_id, current_user: user_id, description: hash_message[:description], reason: Reason.find(reason_id).reason, enable: true).send
      #     else
      #         parse_error()
      #     end
      # rescue
      #   parse_error()
      # end

    end
  end





  #==============================ДАЛЕЕ ИДУТ НЕОБХОДИМЫЕ ФУНКЦИИ=================================================

  #получение хэша причины, указанной пользователем вида {reason: "Зарплата", id: 34}
  def get_id_reason_after_parse(input_word, chat_id)
      jarow = FuzzyStringMatch::JaroWinkler.create()
      input_word = Unicode::downcase(input_word)
      #заполнить хэш id-шниками всех причин по id семьи и Reason.all (и сами причины) и сразу сделать Unicode::downcase("")
      reasons_records = get_records(table_name: 'reasons', add_condition: "and (reasons.local = false or reasons.user = #{current_user.id}) order by reasons.often DESC")
      reasons = reasons_records.map{|x| {reason: Unicode::downcase(x.reason), id: x.id}}
      max_diff = 0
      result_reason = {reason: "", id: nil}

      reasons.each do |reason|
          #разница от 0 до 1 - diff
          diff = jarow.getDistance(reason[:reason], input_word)
          if diff > max_diff and diff >= 0.3
              max_diff = diff
              result_reason = reason
          else
              parse_error(chat_id)
          end

      end

      return result_reason
  end

  # получение хэша (сумма, причина, описание) расперсенной строки
  def telegram_message_parse(str)

      #регулярное выражение примерно типа {sum} [reason][,][description]
      a = /[0-9]{1,}[\s]?([A-Za-zа-яА-Я0-9]*[\s]*)*[,]?[\s]?([A-Za-zа-яА-Я0-9]*[\s]*)*/

      result = {sum: "0", reason: "", description: "Empty"} #0 - id reason of default reason
      #получение части строки, совпадающее с шаблоном - регулярным выражением
      s = a.match(str).to_s
      if s != ""
          message = s.split(",")
          first_part = message[0].split(" ")
          second_part = message[1]

          first_part_size = first_part.size

          sum = message[0]
          #вычисление через wolfram, если выражение хоть сколько-нибудь сложное
          query = Calc_query.new(input: sum)
          sum = query.send
          result[:sum] = sum
          #получение причины
          if main_part_num > 1
              result[:reason] = first_part[1..first_part.size].join(" ")
          end
          #получение описания, если оно есть
          if second_part != nil
              result[:description] = second_part
          end

          #возврат хэша вида {sum: 123, reason:"abv", description: "alal"}
          return result
      else
          return nil
      end

  end

  #вывод об ошибке в телеграм, если парсинг дал nil
  def parse_error(chat_id)
      Message.new(chat_id: chat_id).send_error_message
  end

end
