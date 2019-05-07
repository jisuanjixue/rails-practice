# class Admin::UsersController < ApplicationController
# Rails 的 controller 默认会继承自 ApplicationController，这里改成继承自 AdminController，这样定义在 app/controllers/admin_controller.rb 的所有方法都会被继承下来，包括 layout "admin"
class Admin::UsersController < AdminController
  def index
    # @users = User.all
    # 为了避免 N+1 Query 效能问题, 改成下面的
    @users = User.includes(:groups).all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render "edit"
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :group_ids => [])
  end
  
end
