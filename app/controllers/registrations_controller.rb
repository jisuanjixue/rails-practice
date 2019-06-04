class RegistrationsController < ApplicationController
  before_action :find_event

  def new
  end

  # 每次调用 save 存进数据库前，设定一下 current_step 的值，这样就可以有条件的触发对应的资料验证了
  def create
    @registration = @event.registrations.new(registration_params)
    # 这里针对 ticket 额外用 @event.tickets.find 再检查确定这个票种属于这个活动
    @registration.ticket = @event.tickets.find( params[:registration][:ticket_id] )
    @registration.status = "pending"
    @registration.user = current_user
    @registration.current_step = 1

    if @registration.save
      redirect_to step2_event_registration_path(@event, @registration)
    else
      # 本来的 flash 搭配的是 redirect，这会在跳转后清空 flash 讯息(所以只会显示一次)。
     # 这里因为并不是 redirect 跳转，而是用 render 显示页面，这种情况要改用 flash.now
      flash.now[:alert] = @registration.errors[:base].join("、")
      render "new"
    end
  end

  def step1
    @registration = @event.registrations.find_by_uuid(params[:id])
  end

  def step1_update
    @registration = @event.registrations.find_by_uuid(params[:id])
    @registration.current_step = 1

    if @registration.update(registration_params)
      redirect_to step2_event_registration_path(@event, @registration)
    else
      render "step1"
    end
  end

  def step2
    @registration = @event.registrations.find_by_uuid(params[:id])
  end

  def step2_update
    @registration = @event.registrations.find_by_uuid(params[:id])
    @registration.current_step = 2

    if @registration.update(registration_params)
      redirect_to step3_event_registration_path(@event, @registration)
    else
      render "step2"
    end
  end

  def step3
    @registration = @event.registrations.find_by_uuid(params[:id])
  end

  def step3_update
    @registration = @event.registrations.find_by_uuid(params[:id])
    @registration.current_step = 3
    @registration.status = "confirmed"

    if @registration.update(registration_params)
      flash[:notice] = "报名成功"
      NotificationMailer.confirmed_registration(@registration).deliver_later
      redirect_to event_registration_path(@event, @registration)
    else
      render "step3"
    end
  end

  def show
    @registration = @event.registrations.find_by_uuid(params[:id])
  end

  def registration_params
    params.require(:registration).permit(:ticket_id, :name, :email, :cellphone, :website, :bio)
  end

  def find_event
    @event = Event.find_by_random_id!(params[:event_id])
  end

end
