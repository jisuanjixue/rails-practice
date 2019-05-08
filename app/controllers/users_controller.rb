class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
      # 如果没有 @user.profile，要先新建一个
    @user.create_profile unless @user.profile
  end

  def update
    @user = current_user
      if @user.update(user_params)
        flash[:success] = "修改成功"
        redirect_to edit_user_path
      else
        flash[:error] = "出错了"
        render 'edit'
      end
  end
  
  protected

  def user_params
    params.require(:user).permit(:time_zone,  :profile_attributes => [:id, :legal_name, :birthday, :location, :education, :occupation, :bio, :specialty] )
  end
  
end
