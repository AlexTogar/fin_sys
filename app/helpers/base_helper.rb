# frozen_string_literal: true

module BaseHelper


  def has_family
    if family = User.find(current_user.id).family
      family # return family id
    else
      false
    end
  end

  def get_records (params)
    table_name = params[:table_name]
    add_condition = params[:add_condition]

    # table_class = table_name.singularize.capitalize
    table_class = table_name.split("_").map {|x| x.singularize.capitalize}.join("")

    if table_name != "users"
      if has_family
        eval(table_class).find_by_sql("select * from users, #{table_name} where users.family = #{has_family} and #{table_name}.user = users.id and #{table_name}.deleted = false #{add_condition}")
      else
        eval(table_class).find_by_sql("select * from #{table_name} where #{table_name}.user = #{current_user.id} and #{table_name}.deleted = false #{add_condition}")
      end
    else
      if has_family
        User.find_by_sql("select id, email from users where family = #{has_family} #{add_condition}")
      else
        return [User.find(current_user.id)] #array for use each
      end

    end


  end

  def my_time(s)
    s.scan(/[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}/)[0]
  end

  def family
    if has_family
      User.find_by_sql("select * from users where family = #{has_family} or id = #{current_user.id}")
    else
      [current_user]
    end

  end

  def color (bool_perem, color_true, color_false)
    bool_perem = false if bool_perem == "false"
    bool_perem = true if bool_perem == "true"
    "class = table-#{bool_perem ? color_true : color_false}"
  end

  def balance
    transactions_sum = get_records(table_name: "transactions").inject(0) {|result,elem | Reason.find(elem.reason).sign == false ? result + elem.sum : result - elem.sum }
    debt_sum = get_records(table_name: "debts").inject(0) {|result, elem| elem.sign == true ? result + elem.sum : result - elem.sum}
    capital_sum = get_records(table_name: "capitals").inject(0) {|result, elem| elem.sign == false ? result + elem.sum : result - elem.sum}
    total = transactions_sum - capital_sum + debt_sum
    return {transactions_sum: transactions_sum, debt_sum: debt_sum, capital_sum: capital_sum, total: total}
  end

  def to_bool(str: 'true')
    case str
    when 'true'
      true
    when 'false'
      false
    end
  end

  def set_date_begin(default: Date.today.at_beginning_of_month, alternative: ,param_date_nil: true)
    if param_date_nil
      default
    else
      alternative
    end
  end

  def set_date_end(default: Date.today + 1.day, alternative: , params_date_nil: true)
    if params_date_nil
      default
    else
      alternative
    end
  end



end
