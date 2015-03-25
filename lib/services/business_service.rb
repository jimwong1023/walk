module Services
  class BusinessService < BaseService
    attr_reader :business, :resource

    def initialize(resource=nil)
      @resource = resource
    end

    def create(params, user)
      business = Business.new(params)
      business.owner = user

      business.save!

      @resource = business
    end

    def toggle_open_close
      if @resource
        @resource.open ? @resource.current_waitlist = nil : @resource.current_waitlist = current_waitlist
        @resource.open = !@resource.open
      end

      @resource.save!
    end

    def current_waitlist
      unless @current_waitlist ||= @resource.current_waitlist
        @current_waitlist = @resource.current_waitlist = Waitlist.create(business_id: @resource.id)
        @resource.save!
      end
    end
  end
end