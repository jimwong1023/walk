module Services
  class EntryService < BaseService
    attr_reader :errors

    def create(params)
      if params[:user][:phone_number] != '' && (user = User.find_by_phone_number(params[:user][:phone_number]))
        @resource = Entry.new(first_name: user.first_name, last_name: user.last_name, user_id: user.id, waitlist_id: params[:user][:waitlist_id])
      elsif (params[:user][:phone_number] != '') && (params[:user][:first_name] != '') && (params[:user][:last_name] != '')
        user = User.new(user_params(params))
        user.waiting = true
        if user.save
          @resource = Entry.new(first_name: user.first_name, last_name: user.last_name, user_id: user.id, waitlist_id: params[:user][:waitlist_id])
        else
          @errors = user.errors.full_messages
        end
      else
        @resource = Entry.new(first_name: params[:user][:first_name], last_name: params[:user][:last_name], waitlist_id: params[:user][:waitlist_id])
      end

      @resource.save if @resource
    end

    def update(params)
      if params[:entry]
        @resource = Entry.find_by_id(params[:id])
        text_service.notify(@resource.waitlist)
        @resource.update(active: params[:entry][:active])
        @resource.save
      end
    end

    private
      def user_params(params)
        params.require(:user).permit(:first_name, :last_name, :phone_number)
      end
  end
end