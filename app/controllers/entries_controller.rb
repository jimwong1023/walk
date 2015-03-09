class EntriesController < ApplicationController
  def create
    @waitlist = Waitlist.find_by_id(params[:user][:waitlist_id])
    @business = @waitlist.business

    if params[:user][:phone_number] != ''
      if user = User.find_by_phone_number(params[:user][:phone_number])
        @entry = Entry.new(first_name: user.first_name, last_name: user.last_name, user_id: user.id, waitlist_id: params[:user][:waitlist_id])
      else
        if (params[:user][:first_name] != '') && (params[:user][:last_name] != '')
          user = User.new(user_params)
          user.waiting = true
          if user.save
            @entry = Entry.new(first_name: user.first_name, last_name: user.last_name, user_id: user.id, waitlist_id: params[:user][:waitlist_id])
          else
            flash[:errors] = user.errors.full_messages
          end
        else
          flash[:errors] = ["Please enter first and last names."]
        end
      end
    else
      @entry = Entry.new(first_name: params[:user][:first_name], last_name: params[:user][:last_name], waitlist_id: @waitlist.id)
    end

    unless @entry && @entry.save
      flash[:errors] = @entry.errors.full_messages if @entry
    end

    redirect_to business_path @business
  end

  def update
    entry = Entry.find_by_id(params[:id])
    if params[:entry]
      entry.update(active: params[:entry][:active])
      entry.save!
    end

    @waitlist = Waitlist.find_by_id(params[:entry][:waitlist_id])
    @business = @waitlist.business

    redirect_to business_path @business
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :phone_number)
    end
end