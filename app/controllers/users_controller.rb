class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
    @user = current_user
    @user2 = User.find(current_user.id)
  end

  def update
    byebug
  end

end
