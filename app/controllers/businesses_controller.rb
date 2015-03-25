class BusinessesController < ApplicationController
  before_action :require_login, only: [:create, :show]

  def create
    service.create(business_params, current_user)

    if service.resource.errors.full_messages.length > 0
      flash[:errors] = service.resource.errors.full_messages
      redirect_to root_path
    else
      redirect_to "/businesses/#{service.resource.slug}"
    end
  end

  def show
    resource
    current_waitlist
  end

  def resource
    @resource ||= Business.find_by_id(params[:id]) || Business.find_by_slug(params[:slug])
  end

  def current_waitlist
    unless @current_waitlist ||= resource.current_waitlist
      @current_waitlist = resource.current_waitlist = Waitlist.create(business_id: resource.id)
      resource.save
    end
  end

  def toggle_open_close
    service.toggle_open_close

    if service.resource.errors.full_messages.length > 0
      flash[:errors] = service.resource.errors.full_messages
    end
    redirect_to "/businesses/#{resource.slug}"
  end

  def service
    @service ||= Services::BusinessService.new(resource)
  end

  private

    def business_params
      params.require(:business).permit(:name)
    end
end