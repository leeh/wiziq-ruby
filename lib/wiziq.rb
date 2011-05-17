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

#:attendee_list => array("atnd1","atnd2"), 
    # API Method broken
    def get_account_details
      body = { :psz_usr => @username, :psz_pwd => @password }

      response = call_api(:get_account_details, body)
 
      puts "----------------------"
      puts response.to_hash
      puts "----------------------"
      xml = response.to_hash[:get_account_details_response][:get_account_details_result]
      puts "----------------------"
      xml
      # xml_doc = Nokogiri::XML(xml)
      #       puts xml_doc.to_s
       #       time_zone_ids = xml_doc.xpath("//ALW_TblTimeZones/@ID")
       #       time_zone_names = xml_doc.xpath("//ALW_TblTimeZones/@DisplayName")
       #       time_zone_hash = Hash.new
       #       time_zone_ids.each do |id|
       #         x = time_zone_ids.index(id)
       #         time_zone_hash[id.value] = time_zone_names[x].value
       #       end
       #             
       #       time_zone_hash
     end


    def schedule_new_event(args = {}, attendee_list = {})
      #args[:attendee_list] = attendee_list
      defaults = { 'UserName' => @username, 'Password' => @password }
      # test = :user_code =>  2, :event_name => 'Test schedule class 1', :date_time =>  '05/24/2011 01:00:00 pm', :time_zone => 23, :duration => 60, :is_extendable_by_mins => true, :extended_mins => 30, :max_users => 5, :video_size => 'notset', :description => 'Test schedule new event', :attendee_list => array("atnd1","atnd2"), :show_timer => true, :default_tab => 'p', :recoding_replay => true, :audio_quality => 2, :timer_type => false,  :categorynumber =>  4, :end_session_required => 'entrue'
      event_details = defaults.merge(args)
      body = { 'EventDetails' => event_details }
      response = call_api(:schedule_new_event, body)
      response.to_hash[:schedule_new_event_response][:schedule_new_event_result]
    end


    def update_event(args = {})
      defaults = { 'UserName' => @username, 'Password' => @password }
      event_details = defaults.merge(args)
      body = { 'EventDetails' => event_details }
      response = call_api(:update_new_event, body)
      response.to_hash[:update_new_event_response][:update_new_event_result]
    end

    #DeleteEvent Web Method
    def delete_event(session_code)
      event_details = { :ln_ses_cod  => session_code, :sz_usr_nam => @username, :sz_pwd => @password }
      body  = { 'pstEventDet' => event_details }
      response = call_api(:delete_event, body)
      response.to_hash[:delete_event_response][:delete_event_result]
    end

    #AddAttendeeToSession Web Method
    def add_attendee_to_session(session_code, screenname)
      app_credentials = { 'AppUserName' => @username, 'AppPassword' => @password }
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.AddAttendeeToSession {
          xml.SessionCode session_code
          xml.Attendee {
            xml.ID 1234
            xml.ScreenName screenname
          }
        }
      end
      body  = { 'AppCredentials' => app_credentials, 'AttendeeListXML' => builder.to_xml }
      response = call_api(:add_attendee_to_session, body)    
    end
    
    #AddAttendee Web Method
    def add_attendee(session_code, screenname)
      body = {'AttendeeList' => { 'SessionCode' => session_code, 'AttendeeList' => {'string' => screenname}}}
      response = call_api(:add_attendee, body)
      xml = response.to_hash[:add_attendee_response][:add_attendee_result][:attendee_urls]
      xml_doc = Nokogiri::XML(xml)
      screennames = xml_doc.xpath("//Attendee/@screenName")
      urls = xml_doc.xpath("//Attendee/@Url")
      resulthash = Hash.new
      screennames.each do |screenname|
        x = screennames.index(screenname)
        resulthash[screenname.value] = urls[x].value
      end
      
      resulthash
    end

    #RemoveAttendee Web Method
    def remove_attendee(session_code, screenname)
      body = {'AttendeeList' => { 'SessionCode' => session_code, 'AttendeeList' => {'string' => screenname}}}
      response = call_api(:remove_attendee, body)
      response.to_hash[:remove_attendee_response][:remove_attendee_result]
    end
    
    #GetSessionAttendees Web Method
    #-- Broken
    def get_attendees(session_code)
      # event_details = { 'SessionCode'  => session_code, 'UserName' => @username, 'Password' => @password }
      # body  = { 'Account' => event_details }
      # response = call_api(:get_session_attendees, body)
      #response.to_hash[:get_session_attendees_response][:get_session_attendees_result]
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
        time_zone_hash[id.value.to_i] = time_zone_names[x].value
      end
            
      time_zone_hash
    end

    #Convert date from one timezone to another
    # args: TZ 1 ID, TZ 2 ID, date: 2010-01-26T11:00:00
    def convert_date(from, to, date)
      
      body = { :pin_time_zone_from => from, :pint_time_zone_to => to, :pdt_date => date.strftime("%Y-%m-%dT%H:%M:%S") }
      response = call_api(:convert_date, body) 
      converted_date = (response.to_hash[:convert_date_response][:convert_date_result]).to_s
      DateTime.parse(converted_date)
    end
    
    
    def get_my_package
      body = { 'UserName' => @username, 'Password' => @password }
      response = call_api(:get_my_package, body) 
      xml = response.to_hash[:get_my_package_response][:get_my_package_result]
      xml_doc = Nokogiri::XML(xml)
      package = xml_doc.xpath("//Package/text()")
      if package.nil?
        package  = xml_doc.xpath("//message/text()")
      end
      package
    end

    protected 
      #Call WiZiQ api methods
      def call_api(method, body)
        begin
          response = @client.request(:wiziq, method) do
            soap.namespaces["xmlns:SOAP-ENC"] = "http://schemas.xmlsoap.org/soap/encoding/"
            soap.namespaces["env:encodingStyle"] = "http://schemas.xmlsoap.org/soap/encoding/"
            soap.body = body
          end
        rescue Savon::Error => error
          raise APIError.new(error.to_hash)
        end
      end
  end
  
  class APIError < StandardError
    def initialize(error)
      super("#{error[:fault][:faultcode]}")
    end
  end
  
end

# class String
#   def camelize_api_method_name
#     self.to_s[0].chr.downcase + self.gsub(/(?:^|_)(.)/) { $1.upcase }[1..self.size]
#   end
# end