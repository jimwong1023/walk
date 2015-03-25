module Services
  class BaseService
    def text_service
      @text_service ||= TextService.new
    end
  end
end