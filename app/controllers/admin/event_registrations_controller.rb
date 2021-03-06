require 'csv'

class Admin::EventRegistrationsController < ApplicationController
  before_action :find_event
  before_action :find_registration, only: %i[edit update destroy]
  before_action :require_editor!

  def index
    # 字段查询
    @q = @event.registrations.ransack(params[:q])
    @registrations = @q.result.includes(:ticket).order('id DESC').page(params[:page])
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

    # 时间段查询
    if params[:start_on].present?
      @registrations = @registrations.where('created_at >= ?', Date.parse(params[:start_on]).beginning_of_day)
    end

    if params[:end_on].present?
      @registrations = @registrations.where('created_at <= ?', Date.parse(params[:end_on]).end_of_day)
    end

    # 字段查询，会要完全一模一样(exact match)才会筛选出来
    if params[:registration_id].present?
      @registrations = @registrations.where(id: params[:registration_id].split(','))
    end

    respond_to do |format|
      format.html
      format.xlsx
      format.csv do
        @registrations = @registrations.reorder('id ASC')
        csv_string = CSV.generate do |csv|
          csv << ["报名ID", "票种", "姓名", "状态", "Email", "报名时间"]
          @registrations.each do |r|
            csv << [r.id, r.ticket.name, r.name, t(r.status, scope: 'registration.status'), r.email, r.created_at]
          end
        end
        send_data csv_string, filename: "#{@event.random_id}-registrations-#{Time.now.to_s(:number)}.csv"
      end
    end
  end

  def edit; end

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
