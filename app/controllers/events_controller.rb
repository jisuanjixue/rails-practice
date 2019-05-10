class EventsController < ApplicationController

  def index
    @events = Event.rank(:row_order).all
  end

  def show
    @event = Event.find_by_random_id!(params[:id])
  end

end
