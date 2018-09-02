# frozen_string_literal: true

class BaseController < ApplicationController
  before_action :authenticate_user!

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

  def new_transaction;
  end

  def response_on_new_transaction

    if fast_tran = params[:fast_tran] == nil

      begin
        sum = eval(params[:sum].to_s)
      rescue
        sum = 0 # если не заработает html валидатор
      end
      newTransaction = Transaction.new(
          sum: sum,
          description: params[:description],
          reason: params[:reason],
          user: current_user.id,
          local: params[:local],
          debt_sum: 0, debtor: '',
          deleted: false
      )

      newTransaction.save

      @data = {sum: sum,
               reason: Reason.find(params[:reason]).reason,
               user: current_user.email,
               date: newTransaction.created_at.to_s.split('U')[0],
               sign: Reason.find(params[:reason]).sign,
               id: newTransaction.id
      }

      respond_to do |x|
        x.json {render json: @data.to_json}
      end


    else #if fast_tran != nil


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

    if User.exists?(family: current_family)
      Family.find(current_user.family).destroy
    end

    redirect_to base_join_path, notice: "You have successfully exited the group"
  end

  def delete_transaction
    tran_id = params[:tran_id]
    Transaction.update(tran_id, deleted: "true")
  end

  def new_debt
    # debt_sum = params[:debt_sum]
    # debtor = params[:debtor]
    # you_debtor = params[:you_debtor]
    # sum = debt_sum
    # description = params[:description]
    # if you_debtor
    #   if !Reason.exists?(:reason => "Your debt", :user => current_user.id)
    #     reasonNew = Reason.new(reason: "Your debt", user: current_user.id, sign: true, local: true, deleted: false)
    #     reasonNew.save
    #     reason = reasonNew.id
    #   else
    #     reason = Reason.find(:reason => "Your debt", :user => current_user.id).id
    #   end
    # else
    #   if !Reason.exists?(reason: "Debt to you", user: current_user.id)
    #     reasonNew = Reason.new(reason: "Debt to you", user: current_user.id, sign: false, local: true, deleted: false)
    #     reasonNew.save
    #     reason = reasonNew.id
    #   else
    #     reason = Reason.find(:reason => "Your debt", :user => current_user.id).id
    #   end

    # end
    #
    # user = current_user.id
    # local = true
    # deleted = false
    #
    # Transaction.new(sum: sum, description: description, reason: reason, user: user, local: local, debt_sum: debt_sum, debtor: debtor, you_debtor: you_debtor, deleted: deleted).save
    # redirect_to base_new_transaction_path, notice: "Transaction was successfully created"
  end

end
