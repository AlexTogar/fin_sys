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
    new_Family = Family.new(name: name, connect: connect, user: user, deleted: deleted)
    new_Family.save
  rescue StandardError
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
end
