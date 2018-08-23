class BaseController < ApplicationController
  before_action :authenticate_user!
  def graph
    @data = Reason.all.map{|x| [x.created_at, x.often]}

  end

  def main_tab
  end

  def join
  end

  def response_on_new_transaction
    @data = params
    respond_to do |x|
      x.json {render :json => @data.to_json}
    end
  end
end
