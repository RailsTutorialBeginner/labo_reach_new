class AdminsController < ApplicationController
  before_action :logged_in_admin

  def new
  end

  def show
    @admin = Admin.find(params[:id])
  end
end
