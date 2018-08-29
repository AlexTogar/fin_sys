class BaseController < ApplicationController
  before_action :authenticate_user!
  def graph
    @data = Reason.all.map{|x| [x.created_at, x.often]}

  end

  def main_tab

  end

  def join
  end

  def new_transaction

  end

  def response_on_new_transaction

    newTransaction = Transaction.new(
                    sum: params[:sum],
                    description: params[:description],
                    reason: params[:reason],
                    user: current_user.id,
                    local: params[:local],
                    debt_sum: 0, debtor: "",
                    deleted: false )

    newTransaction.save

    @data = {sum: params[:sum],
             reason: Reason.find(params[:reason]).reason,
             user: current_user.email,
             date: newTransaction.created_at.to_s,
             sign: Reason.find(params[:reason]).sign }

    respond_to do |x|
      x.json {render :json => @data.to_json}
    end



  end
end