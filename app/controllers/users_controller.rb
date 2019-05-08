class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "修改成功"
      redirect_to user_path
    else
      flash[:error] = "出错了"
      render 'edit'
    end
  end
  
  protected

  def find_user
    @user = current_user
    # 如果没有 @user.profile，要先新建一个
    @user.create_profile unless @user.profile
  end

  def user_params
    params.require(:user).permit(:time_zone,  :profile_attributes => [:id, :legal_name, :birthday, :location, :education, :occupation, :bio, :specialty] )
  end
  
end
