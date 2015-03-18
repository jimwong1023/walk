class BusinessesController < ApplicationController
  before_action :require_login, only: [:create, :show]

  def create
    business = Business.new(business_params)
    business.owner = current_user
    if business.save
      redirect_to business_path business
    else
      flash.now[:errors] = business.errors.full_messages
      redirect_to root_path
    end
  end

  def show
    business
    current_waitlist
  end

  def business
    @business ||= Business.find_by_id(params[:id])
  end

  def current_waitlist
    unless @current_waitlist ||= business.current_waitlist
      @current_waitlist = business.current_waitlist = Waitlist.create(business_id: business.id)
      business.save
    end
  end

  def toggle_open_close
    if business
      business.open ? business.current_waitlist = nil : business.current_waitlist = current_waitlist
      business.open = !business.open
    end
    unless business.save
      flash.now[:errors] = business.errors.full_messages
    end
    redirect_to business_path business
  end

  private
    
    # def get_current_waitlist restaurant
    #   @waitlist = restaurant.waitlists.last

    #   if !@waitlist || new_waitlist?(@waitlist)

    #     @waitlist = Waitlist.new
    #     @waitlist.restaurant = restaurant

    #     if @waitlist.save
    #       return @waitlist
    #     else
    #       flash[:notice] = waitlist.errors.full_messages
    #     end
    #   end

    #   @waitlist
    # end

    # def new_waitlist? waitlist
    #   time_now = Time.now.utc.in_time_zone("Pacific Time (US & Canada)")

    #   if (0 <= time_now.hour) && (time_now.hour < 5)
    #     day = (time_now - 1.day).day
    #     start_time = time_now.change(day: day, hour: 5, min: 0)
    #     end_time = time_now.change(hour: 4, min: 59, sec: 59)
    #   else
    #     day = (time_now + 1.day).day
    #     start_time = time_now.change(hour: 5, min: 0)
    #     end_time = time_now.change(day: day, hour: 4, min: 59, sec: 59)
    #   end

    #   if (start_time <= waitlist.created_at) && (waitlist.created_at < end_time)
    #     return false
    #   end
    #   return true
    # end

    def business_params
      params.require(:business).permit(:name)
    end
end