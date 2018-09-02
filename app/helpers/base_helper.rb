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

    table_class = table_name.singularize.capitalize

    if has_family
       eval(table_class).find_by_sql("select * from users, #{table_name} where users.family = #{has_family} and #{table_name}.user = users.id and #{table_name}.deleted = false #{add_condition}")
    else
       eval(table_class).find_by_sql("select * from #{table_name} where #{table_name}.user = #{current_user.id} and #{table_name}.deleted = false #{add_condition}")
    end

  end

end
