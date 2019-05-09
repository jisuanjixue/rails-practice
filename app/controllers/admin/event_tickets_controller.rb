class Admin::EventTicketsController < AdminController
  before_action :find_event
  before_action :find_ticket, only: [:edit, :update, :destroy]

  def index
    @tickets = @event.tickets
  end

  def new
    @ticket = @event.tickets.new
  end

  def create
    @ticket = @event.tickets.new(ticket_params)
    if @ticket.save
      redirect_to admin_event_tickets_path(@event)
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to admin_event_tickets_path(@event)
    else 
      render "edit"
    end
  end

  def destroy
    if @ticket.destroy
      flash[:success] = '删除成功！'
      redirect_to admin_event_tickets_path(@event)
    else
      flash[:error] = '删除失败'
      redirect_to admin_event_tickets_path(@event)
    end
  end

  protected

  def find_event
    @event = Event.find_by_random_id!(params[:event_id])
  end

  def find_ticket
    @ticket = @event.tickets.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:name, :price, :description)
  end
  
end
