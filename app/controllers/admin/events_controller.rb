class Admin::EventsController < AdminController
  before_action :require_editor!
  def index
    @events = Event.rank(:row_order).all
  end

  def show
    @event = Event.find_by_random_id!(params[:id])
    colors = ['rgba(255, 99, 132, 0.2)',
              'rgba(54, 162, 235, 0.2)',
              'rgba(255, 206, 86, 0.2)',
              'rgba(75, 192, 192, 0.2)',
              'rgba(153, 102, 255, 0.2)',
              'rgba(255, 159, 64, 0.2)']

    ticket_names = @event.tickets.map(&:name)

    status_colors = { 'confirmed' => '#FF6384',
                      'pending' => '#36A2EB' }

    @data1 = {
      labels: ticket_names,
      datasets: Registration::STATUS.map do |s|
                  {
                    label: I18n.t(s, scope: 'registration.status'),
                    data: @event.tickets.map { |t| t.registrations.by_status(s).count },
                    backgroundColor: status_colors[s],
                    borderWidth: 1
                  }
                end
    }

    if @event.registrations.any?
      dates = (@event.registrations.order('id ASC').first.created_at.to_date..Date.today).to_a
      @data3 = {
        labels: dates,
        datasets: Registration::STATUS.map do |s|
          {
            label: I18n.t(s, scope: 'registration.status'),
            data: dates.map  do |d|
              @event.registrations.by_status(s).where('created_at >= ? AND created_at <= ?', d.beginning_of_day, d.end_of_day).count
            end,
            borderColor: status_colors[s]
          }
        end
      }
     end
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
      render 'new'
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
      render 'edit'
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
        total += 1 if event.save
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
      format.json { render json: { message: 'ok' } }
    end
  end

  protected

  def event_params
    params.require(:event).permit(:name, :description, :random_id, :status, :remove_images, :category_id, tickets_attributes: %i[id name description price _destroy], images: [])
  end
end
