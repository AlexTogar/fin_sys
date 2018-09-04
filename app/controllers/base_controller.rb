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

  def main_tab;
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

  def create_new_reason
    begin
      reason = params[:reason]
      sign = params[:sign]
      often = 0
      local = params[:local]
      user = current_user.id
      deleted = false

      newReason = Reason.new(reason: reason, sign: sign, often: often, local: local, user: user, deleted: deleted)
      newReason.save

      redirect_to base_new_reason_path, notice: 'Reason was successfully created.'
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
    sum = params[:sum]
    you_debtor = params[:you_debtor]
    debtor = params[:debtor]
    reason = params[:reason]
    description = params[:description]
    user = current_user.id
    local = params[:local]
    deleted = false
    you_debtor ? sign = true : sign = false
    debtNew = Debt.new(sum: sum, you_debtor: you_debtor, debtor:debtor, description: description, user: user, local: local, deleted: deleted, sign: sign)
    debtNew.save

    redirect_to base_new_transaction_path, notice: "Debt was successfully created"


  end

end
