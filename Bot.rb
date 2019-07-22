
  require_relative "Calc_query"
  require_relative "Telegram"
  require_relative "app/helpers/base_helper.rb"
  include Calculate
  include My_telegram
  include BaseHelper

  require_relative "app/models/reason"
  require_relative "app/models/transaction"
  require_relative "app/models/user"
#   require_relative "app/helpers/base_helper.rb"

  require 'fuzzystringmatch'

  require 'unicode'

#==============================ДАЛЕЕ ИДУТ НЕОБХОДИМЫЕ ФУНКЦИИ=================================================
#функция определния числа
def easy_number?(string_number: number)
    reg = /[0-9]*/.match(string_number).to_s
    if reg != string_number
        false
    else
        true
    end
end

  #получение хэша причины, указанной пользователем вида {reason: "Зарплата", id: 34}
def get_reason_after_parse(input_word, chat_id)
    jarow = FuzzyStringMatch::JaroWinkler.create()
    input_word = Unicode::downcase(input_word)
    #заполнить хэш id-шниками всех причин по id семьи и Reason.all (и сами причины) и сразу сделать Unicode::downcase("")
    reasons_records = get_reasons() #reasons миши
    reasons = reasons_records.map{|x| {reason: Unicode::downcase(x.reason), id: x.id}}
    max_diff = 0
    result_reason = {reason: "", id: nil}

    reasons.each do |reason|
        #разница от 0 до 1 - diff
        diff = jarow.getDistance(reason[:reason], input_word)
        if diff > max_diff and diff >= 0.5
            max_diff = diff
            result_reason = reason
        end
    end

    return result_reason
end

def get_reasons()
    return Reason.find_by_sql("select * from users, reasons where users.family = #{User.find(2).family} 
        and reasons.user = users.id 
        and reasons.deleted = false 
        and (reasons.local = false or reasons.user = #{1}) 
        order by reasons.often DESC")
end


# получение хэша (сумма, причина, описание) расперсенной строки
def telegram_message_parse(str)
    #регулярное выражение примерно типа {sum} [reason][,][description]
    a = /[\.\*\/\+\-\(\)]{0,}([0-9]{1,}[\.\*\/\+\-\(\)]{0,})*([\s]?([A-Za-zа-яА-Я0-9]*[\s]*)*[,]?[\s]?([A-Za-zа-яА-Я0-9]*[\s]*)*)?/

    result = {sum: "0", reason: "", description: "Empty"} #0 - id reason of default reason
    #получение части строки, совпадающее с шаблоном - регулярным выражением
    s = a.match(str).to_s
    if s != ""
        message = s.split(",")
        first_part = message[0].split(" ")
        second_part = message[1]

        first_part_size = first_part.size

        sum = first_part[0]
        #вычисление через wolfram, если выражение - не просто число
        if !easy_number?(string_number: sum)
            begin
                query = Calc_query.new(input: sum)
                sum = query.send
            rescue StandardError => msg
                return nil
                Message.new().send_text("Ошибка в разобре математичского выражения: #{msg}")
            end
        end

        result[:sum] = sum

        #получение причины
        if first_part_size > 1
            result[:reason] = first_part[1..first_part.size].join(" ")
        end
        #получение описания, если оно есть
        if second_part != nil
            result[:description] = second_part
        end

        #возврат хэша вида {sum: 123, reason:"abv", description: "alal"}
        if result[:reason] == ""
            #самая популярная причина:
            popular_reason = Reason.order("often desc").first
            result[:reason] = popular_reason.reason
        end
        
        return result
    else
        return nil
    end

end
# ===========================КОНЕЦ ДОПОЛНИТЕЛЬНЫХ ФУНКЦИЙ==================================

  token = ENV["telegram_token"]

  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|

        #блок обработки ошибок
        chat_id = message.chat.id

        case chat_id
        when 479_039_553
            user_id = 2 #alex chat
        when 299_454_049
            user_id = 1 #mihail chat
        end

        case message.text

        when "/balance"
            #output balance
            Message.new(chat_id: chat_id).send_text("Ваш Баланс: #{balance}")
        when "/revert"
            #Код обработки удаления последней неудаленной транзакции данного пользователя
            #поиск последней транзакции
            last_transaction = Transaction.all
            .where(deleted: false, user: user_id)
            .order("created_at desc").first

            #удаление транзакции
            Transaction.update(last_transaction.id, deleted: true)
            Reason.update(last_transaction.reason, often: Reason.find(last_transaction.reason).often - 1)
            #Сообщение пользователю
            Message.new(chat_id: chat_id).send_text("Транзакция успешно удалена (#{last_transaction.sum}р на #{Reason.find(last_transaction.reason).reason})")

        else
            begin
                hash_message = telegram_message_parse(message.text)
                if hash_message != nil
                    chat_id = message.chat.id
                    case chat_id
                    when 479_039_553 #alex chat
                        user_id = 2 #check database
                    when 299_454_049 #miha chat
                        user_id = 1 #check database
                    else
                        Message.new().send_text("Попытка постороннего обращения: text:#{message.text}; chat_id: #{chat_id}")
                    end

                    reason_id = get_reason_after_parse(hash_message[:reason], chat_id)[:id]
                    if reason_id.nil?
                        Message.new(chat_id: chat_id).send_text("Причина введена некорректно")
                    else
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
                        #send message to user (alex/mihail)
                        
                        Message.new(chat_id: chat_id, 
                            sum: hash_message[:sum],
                            current_user: User.find(user_id),
                            description: hash_message[:description], 
                            reason: Reason.find(reason_id).reason, 
                            enable: true).send
                    end


                else
                    Message.new().send_text("?"*(rand(3)+1))
                end
            rescue StandardError => msg
                Message.new().send_text("Error: #{msg}")
            end
        end

    end
  end
