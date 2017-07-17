class WelcomeController < ApplicationController
  def index
    flash[:notice] = " 测试"
  end
end
