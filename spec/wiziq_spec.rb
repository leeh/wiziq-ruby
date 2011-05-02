require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

#module Wiziq
describe "Wiziq API" do

  before do
    @username = "demoaccount"
    @password = "wiziq123"
  end
  

  it "should not raise an error if the username and password are correct"
  
  it "should raise an error if the username and password are not provided" do
#    assert_raise(ArgumentError) do
    api = Wiziq::API.new()
  end
  
  
  #it "should raise an error if the username and password are incorrect"
  
  it "should get time zones" do
    wiziq = Wiziq::API.new(@username, @password)
    wiziq.should respond_to(:get_time_zones)  
  end
  
end