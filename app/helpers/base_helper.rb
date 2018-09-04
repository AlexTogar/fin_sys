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
        User.find_by_sql("select id, email from users where family = #{has_family}")
      else
        return [User.find(current_user.id)] #array for use each
      end

    end


  end

  def my_time(s)
    s.scan(/[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}/)[0]
  end

end
