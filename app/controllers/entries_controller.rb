class EntriesController < ApplicationController
  def create
    @waitlist = Waitlist.find_by_id(params[:user][:waitlist_id])
    @business = @waitlist.business
    service.create(params)

    if service.errors && service.errors.length > 0
      flash[:errors] = service.errors
    end

    redirect_to "/businesses/#{@business.slug}"
  end

  def update
    service.update(params)

    @waitlist = Waitlist.find_by_id(params[:entry][:waitlist_id])
    @business = @waitlist.business

    if service.errors && service.errors.length > 0
      flash[:errors] = service.errors
    end

    redirect_to "/businesses/#{@business.slug}"
  end

  def service
    @service ||= Services::EntryService.new
  end
end