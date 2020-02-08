class EventsController < ApplicationController
  before_action :logged_in_school, only: [:new, :create]
  before_action :logged_in_school_or_admin, only: :update
  before_action :logged_in_admin, only: :destroy
  before_action :correct_event_or_admin, only: :update

  def new
    @event = Event.new
  end

  def index
    if admin_logged_in?
      @events = Event.all.paginate(page: params[:page])
    else
      @events = Event.where(deleted: 0).paginate(page: params[:page])
    end
  end

  def show
    @event = Event.find(params[:id])
    if !(admin_logged_in?)
      redirect_to events_url and return unless @event.deleted == 0
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

  # イベントの編集自体は今の所未実装
  def update
    @event = Event.find(params[:id])
    if !(@event.deleted?)
      if @event.update_attributes(event_logical_param)
        flash[:success] = "deleted!"
        redirect_to events_url and return
      else
        render @event and return
      end
    else
      if admin_logged_in?
        if @event.update_attributes(event_logical_param)
          flash[:success] = "deleted column changed!"
          redirect_to events_url and return
        else
          render @event and return
        end
      else
        flash[:danger] = "Your account has been suspended."
        redirect_to root_url and return
      end
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

    def event_logical_param
      params.require(:event).permit(:deleted)
    end

    def correct_event_or_admin
      if admin_logged_in?
        @event = Event.find_by(id: params[:id])
      else
        @event = current_school.events.find_by(id: params[:id])
        redirect_to root_url if @event.nil?
      end
    end
end
