class BaseController < ApplicationController
  before_action :authenticate_user!
  def graph
  end

  def main_tab
  end

  def join
  end
end
