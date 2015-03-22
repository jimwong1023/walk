class BusinessesController < ApplicationController
  before_action :require_login, only: [:create, :show]

  def create
    biz = Business.new(business_params)
    biz.owner = current_user
    if biz.save
      redirect_to "/businesses/#{biz.slug}"
    else
      flash.now[:errors] = biz.errors.full_messages
      redirect_to root_path
    end
  end

  def show
    business
    current_waitlist
  end

  def business
    @business ||= Business.find_by_id(params[:id]) || Business.find_by_slug(params[:slug])
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
    redirect_to "/businesses/#{business.slug}"
  end

  private

    def business_params
      params.require(:business).permit(:name)
    end
end