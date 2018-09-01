# frozen_string_literal: true

class BaseController < ApplicationController
  before_action :authenticate_user!

  def test_action
    @data = params
    render json: @data
  end

  def graph
    @data = Transaction.all.map { |x| [x.created_at, x.sum] }
  end

  def main_tab; end

  def join; end

  def new_family
    name = params[:name]
    connect = params[:connect]
    user = current_user.id
    deleted = false
    action = params[:my_action]
    if action == "true"

      if family_size = Family.find_by_sql("select * from families where name = #{name} and connect = #{connect}") == nil
        new_Family = Family.new(name: name, connect: connect, user: user, deleted: deleted)
        new_Family.save
        User.update(current_user.id, family: new_Family.id)
        redirect_to base_join_path, notice: "The group was created successfully"
      else
        redirect_to base_join_path, notice: "Error, select other name of connection password"
      end

    else
      family_connect = Family.find_by_sql("select * from families where name = #{name} and connect = #{connect}")
      User.update(current_user.id, :family => family_connect.id)
      redirect_to base_join_path, notice: "The connection successfully completed"

    end

  end

  def new_transaction; end

  def response_on_new_transaction
    begin
      sum = eval(params[:sum].to_s)
    rescue StandardError
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

    @data = { sum: sum,
              reason: Reason.find(params[:reason]).reason,
              user: current_user.email,
              date: newTransaction.created_at.to_s.split('U')[0],
              sign: Reason.find(params[:reason]).sign }

    respond_to do |x|
      x.json { render json: @data.to_json }
    end
  rescue StandardError
  end

  def create_new_reason
    begin
    reason = params[:reason]
    sign = params[:sign]
    often = 0
    local = params[:local]
    user = current_user.id
    deleted = false

    newReason = Reason.new(reason: reason,sign: sign,often: often,local: local,user: user,deleted: deleted)
    newReason.save

    redirect_to base_new_reason_path , notice: 'Reason was successfully created.'
    rescue
      redirect_to base_new_reason_path, notice: "Error, reason cannot be added"
    end

  end

end
