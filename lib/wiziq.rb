require 'savon'

module Wiziq
  class API

    # Blank Slate
    instance_methods.each do |m|
      undef_method m unless m.to_s =~ /^__|object_id|method_missing|respond_to?|to_s|inspect/
    end

    def initialize(username, password)
      raise ArgumentError.new('You must provide a username.') if username.nil?
      raise ArgumentError.new('You must provide a password.') if password.nil?
            
      Savon.configure do |config|
        config.log = true            # disable logging
        config.log_level = :debug      # changing the log level
        #config.logger = Rails.logger  # using the Rails logger
      end

      @username = username
      @password = password
         
      # @logger = Logging.logger(STDOUT)
      #      @logger.level = :warn
      #  
      @client = Savon::Client.new do
        wsdl.document = "http://authorlive.com/aGLIVE/aGLive.asmx?WSDL"
      end
      
    end

    def get_time_zones
      begin
        response = @client.request :get_time_zones do
          soap.version = 2
          soap.body = { :psz_usr_nam => @username, :psz_pwd => @password }
        end
        # @logger.debug response.to_xml
        xml = response.xml
        xml
      rescue Savon::Error => error
        puts error
        # @logger error.to_s
      end
    end


    def respond_to?(api_method) # :nodoc:
      @client.call(api_method, {})
      #rescue Savon::SOAP::Fault => error
      #   error.faultCode == -32601 ? false : true 
    end

  end
  
  class APIError < StandardError
    def initialize(error)
      super("<#{error.faultCode}> #{error.message}")
    end
  end
  
end

# class String
#   def camelize_api_method_name
#     self.to_s[0].chr.downcase + self.gsub(/(?:^|_)(.)/) { $1.upcase }[1..self.size]
#   end
# end