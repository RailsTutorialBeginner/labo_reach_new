class EventsController < ApplicationController
  before_action :logged_in_school, only: [:create, :destroy]
  before_action :correct_school, only: :destroy

  def index
    @events = Event.all.paginate(page: params[:page])
  end

  # 後で使う？
  def show
    if school_logged_in?
      @feed_items = current_school.feed.paginate(page: params[:page])
    end
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
      params.require(:event).permit(:content, :picture)
    end

    def correct_school
      @event = current_school.events.find_by(id: params[:id])
      redirect_to root_url if @event.nil?
    end
end
