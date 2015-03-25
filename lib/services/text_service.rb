module Services
  class TextService
    def initialize
      account_sid = ENV['TWILIO_SID']
      auth_token = ENV['TWILIO_AUTH']
       
      @client = Twilio::REST::Client.new account_sid, auth_token
    end

    def notify(waitlist)
      binding.pry
    end
  end
end