class BusinessesController < ApplicationController
  before_action :require_login, only: [:create, :show]

  def create
    business = Business.new(business_params)
    business.owner = current_user

    if business.save
      redirect_to "/businesses/#{business.slug}"
    else
      flash[:errors] = business.errors.full_messages
      redirect_to root_path
    end
  end

  def show
    resource
    current_waitlist
  end

  def resource
    @resource ||= Business.find_by_id(params[:id]) || Business.find_by_slug(params[:slug])
  end

  def toggle_open_close
    resource.toggle_open_close

    redirect_to "/businesses/#{resource.slug}"
  end

  def current_waitlist
    @current_waitlist ||= resource.current_waitlist
  end

  def business_service
    @business_service ||= Services::BusinessService.new(resource)
  end

  private

    def business_params
      params.require(:business).permit(:name)
    end
end