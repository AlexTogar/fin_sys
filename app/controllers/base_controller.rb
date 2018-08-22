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
end
