class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    authorize! :create, User
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t "flash.sign_up.success"
      redirect_to login_path
    else
      flash[:error] = t "flash.sign_up.fail"
      render "new", status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(User::USER_PARAMS)
  end
end
