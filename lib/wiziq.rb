require 'savon'
require 'nokogiri'
require 'net/http'

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
      body = { :psz_usr_nam => @username, :psz_pwd => @password }
      
      response = call_api(:get_time_zones, body)
      
      xml = response.to_hash[:get_time_zones_response][:get_time_zones_result]
      xml_doc = Nokogiri::XML(xml)
      time_zone_ids = xml_doc.xpath("//ALW_TblTimeZones/@ID")
      time_zone_names = xml_doc.xpath("//ALW_TblTimeZones/@DisplayName")
      time_zone_hash = Hash.new
      time_zone_ids.each do |id|
        x = time_zone_ids.index(id)
        time_zone_hash[id.value] = time_zone_names[x].value
      end
            
      time_zone_hash
    end

    #Call WiZiQ api methods
    def call_api(method, body)
      begin
        response = @client.request(:wiziq, method) do
          soap.namespaces["xmlns:SOAP-ENC"] = "http://schemas.xmlsoap.org/soap/encoding/"
          soap.namespaces["env:encodingStyle"] = "http://schemas.xmlsoap.org/soap/encoding/"
          soap.body = body
        end
      rescue Savon::Error => error
        Savon.logger.error(error.to_s)
        raise APIError.new(error)
      end
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