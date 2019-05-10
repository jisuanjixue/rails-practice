class Admin::EventsController < AdminController

  def index
    @events = Event.rank(:row_order).all
  end

  def show
    @event = Event.find_by_random_id!(params[:id])
  end

  def new
    @event = Event.new
    @event.tickets.build
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to admin_events_path
    else
      render "new"
    end
  end

  def edit
    @event = Event.find_by_random_id!(params[:id])
    @event.tickets.build if @event.tickets.empty?
  end

  def update
    @event = Event.find_by_random_id!(params[:id])

    if @event.update(event_params)
      redirect_to admin_events_path
    else
      render "edit"
    end
  end

  def destroy
    @event = Event.find_by_random_id!(params[:id])
    @event.destroy

    redirect_to admin_events_path
  end

  def bulk_update
    # 关于 Array(params[:ids] 这个用法，如果是 Array([1,2,3]) 会等同于 [1,2,3] 没变，但是 Array[nil] 会变成 [] 空数组，这可以让 .each 方法不会因为 nil.each 而爆错。
    # 如果不这样处理，在没有勾选任何活动就送出的情况，就会爆出 NoMethodError 错误。除非你额外检查 params[:id] 如果是 nil 就返回，但不如用 Array 来的精巧
    total = 0
    Array(params[:ids]).each do |event_id|
      event = Event.find(event_id)
        if params[:commit] == I18n.t(:bulk_update)
          event.status = params[:event_status]
          if event.save
            total += 1
          end
        elsif params[:commit] == I18n.t(:bulk_delete)
          event.destroy
          total += 1
        end
    end

    flash[:alert] = "成功完成 #{total} 项"
    redirect_to admin_events_path
  end

  def reorder
    @event = Event.find_by_random_id!(params[:id])
    @event.row_order_position = params[:position]
    @event.save!

    respond_to do |format|
      format.html { redirect_to admin_events_path }
      format.json { render :json => { :message => "ok" }}
    end
  end

  protected

  def event_params
    params.require(:event).permit(:name, :description, :random_id, :status, :category_id, :tickets_attributes => [:id, :name, :description, :price, :_destroy])
  end

end
