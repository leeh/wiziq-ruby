require 'helper'

class TestWiziq < Test::Unit::TestCase
  # should "probably rename this file and start testing for real" do
  #   flunk "hey buddy, you should probably rename this file and start testing for real"
  # end
  
  
  def setup
    @username = "learnerhill"
    @password = "password"
    
    @wiziq = Wiziq::API.new(@username, @password)
  end
  # 
  # test "get time zones" do
  # end
  
 
  def test_schedule_new_event
       
    defaults = { 'UserCode' =>  '9953', 'IsExtendableByMins' => true, 'ExtendedMins' => 30, 'MaxUsers' => 25, 'VideoSize' => 'NotSet', 'PingTime' => 1, 'ShowTimer' => true, 'AudioQuality' => 2,  'CategoryNumber' => 14, 'EndSessionRequired' => 'enFalse', 'DisplayAttendeeLoginLogout' =>  'enDisplay', 'BrowserCloseMsg' => 'enFalse', 'AttendeeContent' => 'enFalse', 'MathToolBar' =>  'enFalse', 'ChatAlertSound' => 'true', 'ShowEraser' => 'enFalse', 'VideoSharing' => 'true', 'PrintRequired' => 'false', 'SmileysRequired' => 'true', 'ShowConnStatus' =>  'false', 'ShowDisableChatButton' => 'false', 'SecureLogin' => 'false', 'AttendeeList'=>''}
     
    args = {'EventName' => 'CSCMP - M1 Supply Chain Management - through OIPMAC: GroupClassLIVEWebinarB', 'DateTime' =>  '11/11/2011 12:00:00 am', 'TimeZone' => 23, 'Duration' => 60, 'Description' => nil, 'PresenterName' => 'testuser'}
     
    args = defaults.merge(args)
   
    attendee_list = ''
    response = @wiziq.schedule_new_event(args, attendee_list)
  
  end

  def test_update_event
    
    attendee_list = ["demoaccount"]
      
    defaults = { 'UserCode' =>  '9953', 'IsExtendableByMins' => 'enTrue', 'ExtendedMins' => 30, 'MaxUsers' => 25, 'VideoSize' => 'NotSet', 'PingTime' => 1, 'ShowTimer' => true, 'AudioQuality' => 2, 'CategoryNumber' => 14, 'EndSessionRequired' => 'enFalse', 'DisplayAttendeeLoginLogout' =>  'enDisplay', 'BrowserCloseMsg' => 'enFalse', 'AttendeeContent' => 'enFalse', 'MathToolBar' =>  'enFalse', 'ChatAlertSound' => 'enTrue', 'ShowEraser' => 'enFalse', 'VideoSharing' => 'true', 'PrintRequired' => 'false', 'SmileysRequired' => 'true', 'ShowConnStatus' =>  'false', 'ShowDisableChatButton' => 'false', 'SecureLogin' => 'false', 'AttendeeList'=>''}
     
    args = {'SessionCode' =>  '1431872', 'EventName' => 'TEST SCHEDULE Upd', 'DateTime' =>  '11/11/2011 11:00:00 am', 'TimeZone' => 23, 'Duration' => 60, 'Description' => nil, 'PresenterName' => 'testuser'}
     
    args = defaults.merge(args)
    response = @wiziq.update_event(args)
    puts response
  end

    
    # def test_delete_event
    #   begin
    #     response = @wiziq.delete_event('1219644')
    #     puts response
    #   rescue Wiziq::APIError => error
    #     puts "Error: " + error.inspect
    #   end
    # end
  
  # def test_add_attendee
  #   response = @wiziq.add_attendee(1186330, 'leehorrocks2')
  #   puts response
  # end
  #   
  # def test_remove_attendee
  #   response = @wiziq.remove_attendee(1170636, 'leehorrocks')
  #   puts response
  # end
  # 
  # def test_get_session_attendees
  #   response = @wiziq.get_attendees(1170636)
  #   puts response
  # end
  
  # 
  # def test_get_account_details
  #   response = @wiziq.get_account_details
  #   puts "----------------------"
  #   puts response
  # end
  
  # def test_get_my_package
  #   response = @wiziq.get_my_package
  #   puts response
  # end
  

  # 
  # def test_get_time_zones
  #   response = @wiziq.get_time_zones
  # 
  #   puts response.inspect
  #   response.each_key do |r|
  #     puts r.to_s + ": "+ response[r]
  #   end
  # end
  # 
  # def test_convert_date
  #   newdate = @wiziq.convert_date("23", "28", Time.now)
  #   puts newdate
  # end

end
