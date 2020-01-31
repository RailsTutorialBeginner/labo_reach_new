class EventsController < ApplicationController
  before_action :logged_in_school_or_admin, only: [:create, :destroy]
  before_action :correct_school_or_admin, only: :destroy

  def index
    @events = Event.all.paginate(page: params[:page])
  end

  # 後で使う？
  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = current_school.events.build(event_params)
    if @event.save
      flash[:success] = "Event created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @event.destroy
    flash[:success] = "Event deleted"
    redirect_to request.referrer || root_url
  end

  private

    def event_params
      params.require(:event).permit(:name, :content, :picture)
    end

    def correct_school_or_admin
      if admin_logged_in?
        @event = Event.find_by(id: params[:id])
      else
        @event = current_school.events.find_by(id: params[:id])
        redirect_to root_url if @event.nil?
      end
    end
end
