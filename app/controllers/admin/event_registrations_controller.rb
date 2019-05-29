class Admin::EventRegistrationsController < ApplicationController
  before_action :find_event
  before_action :find_registration, :only => [:edit, :update, :destroy]

  def index
    @registrations = @event.registrations.includes(:ticket).order("id DESC")
    # 单选
    if params[:status].present? && Registration::STATUS.include?(params[:status])
      @registrations = @registrations.by_status(params[:status])
    end
    if params[:ticket_id].present?
      @registrations = @registrations.by_ticket(params[:ticket_id])
    end

    # 多选
    if Array(params[:statuses]).any?
      @registrations = @registrations.by_status(params[:statuses])
    end
      
    if Array(params[:ticket_ids]).any?
      @registrations = @registrations.by_ticket(params[:ticket_ids])
    end
  end

  def edit
  end

  def new
    @registration = @event.registrations.new
  end

  def destroy
    @registration = @event.registrations.find_by_uuid(params[:id])
    @registration.destroy

    redirect_to admin_event_registrations_path(@event)
  end

  def create
     @registration = @event.registrations.new(registration_params)
     if @registration.save
      flash[:success] = '新增成功！'
      redirect_to admin_event_registrations_path(@event)
    else
      render 'new'
    end
  end

  def update
    if @registration.update(registration_params)
      flash[:success] = '编辑成功'
      redirect_to admin_event_registrations_path(@event)
    else
      render 'edit'
    end
  end

  protected

  def find_event
    @event = Event.find_by_random_id!(params[:event_id])
  end

  def find_registration
    @registration = @event.registrations.find_by_uuid(params[:id])
  end

  def registration_params
    params.require(:registration).permit(:status, :ticket_id, :name, :email, :cellphone, :website, :bio)
  end
end
