class EntriesController < ApplicationController
  def create
    flash[:errors] = []

    @waitlist = Waitlist.find_by_id(params[:user][:waitlist_id])
    @business = @waitlist.business
    
    if user = User.find_by_phone_number(params[:user][:phone_number])
      entry = Entry.new(first_name: user.first_name, last_name: user.last_name, user_id: user.id, waitlist_id: params[:user][:waitlist_id])
    elsif (params[:user][:phone_number] != '') && (params[:user][:first_name] != '') && (params[:user][:last_name] != '')
      user = User.new(user_params(params))
      user.waiting = true
      if user.save
        entry = Entry.new(first_name: user.first_name, last_name: user.last_name, user_id: user.id, waitlist_id: params[:user][:waitlist_id])
      end
    else
      entry = Entry.new(first_name: params[:user][:first_name], last_name: params[:user][:last_name], waitlist_id: params[:user][:waitlist_id])
    end

    if entry && entry.save
      text_service.notify(entry.waitlist)
    elsif entry && entry.errors.full_messages.length > 0
      flash.now[:errors] << entry.errors.full_messages
    elsif user && user.errors.full_messages.length > 0
      flash.now[:errors] << user.errors.full_messages
    end

    redirect_to "/businesses/#{@business.slug}"
  end

  def update
    flash[:errors] = []

    entry = Entry.find_by_id(params[:id])
    text_service.notify(entry.waitlist)
    entry.update(active: params[:entry][:active])

    @waitlist = Waitlist.find_by_id(params[:entry][:waitlist_id])
    @business = @waitlist.business

    unless entry.save
      flash[:errors] << entry.errors.full_messages
    end

    redirect_to "/businesses/#{@business.slug}"
  end

  private
    def text_service
      @text_service ||= Services::TextService.new
    end

    def user_params(params)
      params.require(:user).permit(:first_name, :last_name, :phone_number)
    end
end