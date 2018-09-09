# frozen_string_literal: true

class BaseController < ApplicationController
  before_action :authenticate_user!
  include BaseHelper


  def test_action
    @data = params
    render json: @data
  end

  def graph
    @data = Transaction.all.map {|x| [x.created_at, x.sum]}
  end


  def main_tab

  end

  def new_fast_transaction
    @fastTransactions = FastTransaction.where(deleted: "false", user: current_user.id)
  end


  def join;
  end

  def new_family
    name = params[:name]
    connect = params[:connect]
    user = current_user.id
    deleted = false
    action = params[:my_action]
    if action == "true"

      if family_size = Family.find_by_sql("select * from families where name = '#{name}' ").size == 0
        new_Family = Family.new(name: name, connect: connect, user: user, deleted: deleted)
        new_Family.save
        User.update(current_user.id, family: new_Family.id)
        redirect_to base_join_path, notice: "The group was created successfully"
      else
        redirect_to base_join_path, notice: "This name is already taken, choose another"
      end

    else
      if Family.exists?(name: name, connect: connect)
        family_connect = Family.find_by_sql("select * from families where name = '#{name}' and connect = '#{connect}' ")[0]
        User.update(current_user.id, family: family_connect.id)
        redirect_to base_join_path, notice: "The connection successfully completed"
      else
        redirect_to base_join_path, notice: "Invalid name or connection password"
      end

    end

  end

  def new_transaction
    @transactions = get_records(table_name: "transactions", add_condition: "order by transactions.created_at DESC")[0..4]
    @reasons = get_records(table_name: "reasons", add_condition: "order by reasons.often DESC")

    @my_debts = Debt.where(deleted: false, user: current_user.id).order("created_at desc")

  end

  def delete_debt
    id = params[:id]
    begin
      Debt.update(id, deleted: true)
      redirect_to base_new_transaction_path, notice: "Debt was successfully deleted"
    rescue
      redirect_to base_new_transaction_path, notice: "Debt can not be deleted"
    end

  end


  def response_on_new_transaction
    fast_tran = params[:fast_tran]
    if fast_tran == nil

      begin
        sum = eval(params[:sum].to_s).to_i
      rescue
        sum = 0 # если не заработает html валидатор
      end
      newTransaction = Transaction.new(
          sum: sum,
          description: params[:description],
          reason: params[:reason],
          user: current_user.id,
          local: params[:local],
          deleted: false
      )
      Reason.update(params[:reason], often: Reason.find(params[:reason]).often + 1)

      newTransaction.save

      @data = {sum: sum,
               reason: Reason.find(params[:reason]).reason,
               user: current_user.email,
               date: my_time(newTransaction.created_at.to_s),
               sign: Reason.find(params[:reason]).sign,
               id: newTransaction.id
      }

      respond_to do |x|
        x.json {render json: @data.to_json}
      end


    else #if fast_tran != nil
      fast_tran = FastTransaction.find(fast_tran)

      newTransaction = Transaction.new(
          sum: fast_tran.sum,
          description: "",
          reason: fast_tran.reason,
          user: fast_tran.user,
          local: fast_tran.local,
          deleted: false
      )
      Reason.update(fast_tran.reason, often: Reason.find(fast_tran.reason).often + 1)

      newTransaction.save

      @data = {sum: fast_tran.sum,
               reason: Reason.find(fast_tran.reason).reason,
               user: User.find(fast_tran.user).email,
               date: my_time(newTransaction.created_at.to_s),
               sign: Reason.find(fast_tran.reason).sign,
               id: newTransaction.id
      }

      respond_to do |x|
        x.json {render json: @data.to_json}
      end

    end

  end

  def new_reason
    @my_reasons = Reason.where(deleted: "false", user: current_user.id).order(:created_at)
  end

  def delete_reason
    id = params[:id]
    begin
      Reason.update(id, deleted: "true")
      redirect_to base_new_reason_path, notice: "Reason was successfully deleted"
    rescue
      redirect_to base_new_reason_path, notice: "Reason can not be deleted"
    end

  end

  def create_new_reason
    begin
      reason = params[:reason]
      sign = params[:sign]
      often = 0
      local = params[:local]
      user = current_user.id
      deleted = false

      newReason = Reason.new(reason: reason, sign: sign, often: often, local: local, user: user, deleted: deleted)
      if Reason.exists?(reason: reason, user: user)
        redirect_to base_new_reason_path, notice: "Reason already exists"
      else
        newReason.save
        redirect_to base_new_reason_path, notice: 'Reason was successfully created.'
      end

    rescue
      redirect_to base_new_reason_path, notice: "Error, reason cannot be added"
    end

  end

  def leave_the_group
    current_family = current_user.family

    User.update(current_user.id, family: nil)

    if !User.exists?(family: current_family)
      Family.find(current_user.family).destroy
    end

    redirect_to base_join_path, notice: "You have successfully exited the group"
  end

  def delete_transaction
    tran_id = params[:tran_id]
    Transaction.update(tran_id, deleted: "true")
  end


  def create_new_fast_transaction
    name = params[:name]
    reason = params[:reason]
    begin
      sum = eval(params[:sum].to_s).to_i
    rescue
      sum = 0
    end
    user = current_user.id
    local = params[:local]
    deleted = false

    begin
      newFastTran = FastTransaction.new(name: name, reason: reason, sum: sum, user: user, local: local, deleted: deleted)
      newFastTran.save
    rescue
      redirect_to base_new_fast_transaction_path, notice: "Fast transaction cannot be created"
    end

    redirect_to base_new_fast_transaction_path, notice: "Fast transaction was successfully created"

  end

  def new_debt

    begin
      sum = eval(params[:sum].to_s).to_i
    rescue
      sum = 0 # если не заработает html валидатор
    end

    begin
      you_debtor = params[:you_debtor]
      you_debtor == "false" ? you_debtor = false : you_debtor = true
      debtor = params[:debtor]
      reason = params[:reason]
      description = params[:description]
      user = current_user.id
      local = params[:local]
      deleted = false
      you_debtor ? sign = true : sign = false
      debtNew = Debt.new(sum: sum, you_debtor: you_debtor, debtor: debtor, description: description, user: user, local: local, deleted: deleted, sign: sign)
      debtNew.save
      redirect_to base_new_transaction_path, notice: "Debt was successfully created"
    rescue
      redirect_to base_new_transaction_path, notice: "Debt canntot be added"
    end

  end


  def update_table
    date_begin = params[:date_begin].to_time
    date_end = params[:date_end].to_time
    user = params[:user] # all или id пользователя
    type = params[:type] # all/personal/joint
    reason = params[:reason] #all или id причины
    sign = params[:sign] # all, exspense, profit

    delete_condition = "transactions.deleted = false"

    records = []
    start_records = Transaction
                        .where(created_at: (date_begin..date_end + 1.day))
                        .where(delete_condition)
                        .order(created_at: "desc")
    start_records.each do |x|
      flag = true
      if user == "all"
        if has_family
          flag = false if User.find(x.user).family != has_family
        else
          flag = false if x.user != current_user.id
        end

      else
        flag = false if x.user.to_s != user
      end

      case type
      when "personal"
        flag = false if x.local != true
      when "joint"
        flag = false if x.local == true
      end

      if reason != "all"
        flag = false if x.reason.to_s != reason
      end

      case sign
      when "expense"
        flag = false if Reason.find(x.reason).sign == false
      when "profit"
        flag = false if Reason.find(x.reason).sign == true
      end


      records << x if flag

    end
    col_sum = records.inject(0) {|result, elem| Reason.find(elem.reason).sign == false ? result + elem.sum : result - elem.sum }

    i = 0
    @data = Hash.new()
    records.each do |tran|
      @data[i] = {id: tran.id,
                  sum: tran.sum,
                  user: User.find(tran.user).email,
                  reason: Reason.find(tran.reason).reason,
                  description: (tran.description == "" ? "Empty" : tran.description),
                  date: my_time(tran.created_at.to_s),
                  sign: Reason.find(tran.reason).sign,
                  size: records.size,
                  col_sum: col_sum}
      i = i + 1
    end

    respond_to do |x|
      x.json {render json: @data}
    end

  end


  def set_aside
    @savings_users_sum = (family.map {|x| Capital.exists?(user: x.id) ? [x.email, Capital.where(user: x.id, deleted: false, sign: false).pluck(:sum).sum - Capital.where(user: x.id, deleted: false, sign: true).pluck(:sum).sum, Capital.where(user: x.id, deleted: false, sign: false).pluck(:sum).sum, Capital.where(user: x.id, deleted: false, sign: true).pluck(:sum).sum] : [x.email, 0,0,0]}).compact
    @total = @savings_users_sum.inject(0) {|result, elem| elem != nil ? result + elem[1] : result + 0}
    @total = 0 if @total == nil
  end


  def create_deposit
    sign = params[:sign]
    begin
      sum = eval(params[:sum].to_s).to_i
    rescue
      sum = 0 # если не заработает html валидатор
    end
    user = current_user.id
    savings_users_sum = (family.map {|x| Capital.exists?(user: x.id) ? [x.email, Capital.where(user: x.id, deleted: false, sign: false).pluck(:sum).sum - Capital.where(user: x.id, deleted: false, sign: true).pluck(:sum).sum, Capital.where(user: x.id, deleted: false, sign: false).pluck(:sum).sum, Capital.where(user: x.id, deleted: false, sign: true).pluck(:sum).sum] : [x.email, 0,0,0]}).compact

    current_sum = savings_users_sum.inject(0) {|result, elem| result + elem[1]}
    if sign == "true"
      if current_sum >= sum.to_i
        capitalNew = Capital.new(sum: sum, user: user, deleted: false, sign: sign)
        capitalNew.save
        redirect_to base_set_aside_path, notice: "#{sum} rubles successfully withdrawn"
      else
        redirect_to base_set_aside_path, notice: "Too much money"
      end
    else

      capitalNew = Capital.new(sum: sum, user: user, deleted: false, sign: sign)
      capitalNew.save

      redirect_to base_set_aside_path, notice: "#{sum} rubles pending successful"
    end

  end

  def delete_fast_transaction
    id = params[:id]
    FastTransaction.update(id, deleted: true)
    redirect_to base_new_fast_transaction_path, notice: "Fast transaciton was successfully deleted"
  end




  def update_graph
    date_begin = params[:date_begin].to_time
    date_end = params[:date_end].to_time
    user = params[:user] # all или id пользователя
    sign = params[:sign] # balance, all, exspense, profit

    delete_condition = "transactions.deleted = false"

    records = []
    start_records = Transaction
                        .where(created_at: (date_begin..date_end + 1.day))
                        .where(delete_condition)
                        .order(created_at: "desc")
    if sign != "b" #balanse
      start_records.each do |x|
        flag = true
        if user == "all"
          if has_family
            flag = false if User.find(x.user).family != has_family
          else
            flag = false if x.user != current_user.id
          end

        else
          flag = false if x.user.to_s != user
        end

        case sign
        when "expense"
          flag = false if Reason.find(x.reason).sign == false
        when "profit"
          flag = false if Reason.find(x.reason).sign == true
        end

        records << x if flag
      end

      names = records.map {|elem| {id: elem.user, name: User.find(elem.user).email }}.uniq

      names.each do |name|
        data = records.map{|tran| {sum: tran.sum, sign: Reason.find(tran.reason).sign} if tran.user == name[:id]}
        name[:data] = data
      end
      @data = names

    end


    respond_to do |x|
      x.json {render json: @data}
    end

  end


end
