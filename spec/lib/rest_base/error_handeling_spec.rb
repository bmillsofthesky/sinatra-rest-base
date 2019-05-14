require 'spec_helper'

describe RestBase::Application do
  before(:each) do
    @headers = { 'HTTP_AUTHORIZATION' => 'key1' }  
  end
  
  describe :successful_error do
    it "should provide cb error with 200 status" do
      expected_body = {
        :errors => [
          {
            :type => "CBError",
            :code => "400",
            :message => "A CBError Message"
          }
        ]
      }
      
      get '/raise_successful_error', {}, @headers
      
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(expected_body.to_json)
    end
  end
  
  describe :not_found_404 do
    it "should provide standard not found error" do
      expected_body = {
        :errors => [ 
          {
            :type => "Not Found",
            :code => "404",
            :message => "Endpoint Not Found"
          }
        ]
      }
      
      get '/idontexist', {}, @headers
      
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq(expected_body.to_json)
    end
  end
  
  describe :invalid_request do
    it "should return the invalid param messages" do
      expected_body = {
        :errors => [
          {
            :type => "Invalid Request Format",
            :code => "400",
            :message => "param1 is not valid: Must be a String"
          },
          {
            :type => "Invalid Request Format",
            :code => "400",
            :message => "param2 is not valid: Must be an Integer"
          }
        ]
      }
      
      get '/invalid_request', {}, @headers
      
      expect(last_response.body).to eq(expected_body.to_json)
    end
  end

  describe :cb_error do
    it "should return a CBError response" do
      expected_body = {
        :errors => [
          {
            :type => "CBError",
            :code => "407",
            :message => "A CBError Message"
          }
        ]
      }
      
      get '/cb_error_handeling', {}, @headers
      
      expect(last_response.body).to eq(expected_body.to_json)
    end
    
    it "should return a CBError response with messages" do
      expected_body = {
        :errors => [
          {
            :type => "Error",
            :code => "400",
            :message => "Error"
          }
        ],
        :messages => ["Test Message"]
      }
      
      get '/cb_error_with_messages', {}, @headers
      
      expect(last_response.body).to eq(expected_body.to_json)
    end
    
    it "should return a CBError response with forensics" do
      expected_body = {
        :errors => [
          {
            :type => "Error",
            :code => "400",
            :message => "Error"
          }
        ],
        :forensics => ["Test Forensic"]
      }
      
      @headers["Forensics"] = "TRUE"
      
      get '/cb_error_with_forensics', {}, @headers
      
      expect(last_response.body).to eq(expected_body.to_json)
    end
    
    it "should return an Overridden CBError response" do
      expected_body = {
        :errors => [
          {
            :type => "Error",
            :code => "400",
            :message => "An Overridden CBError Message"
          }
        ]
      }
      
      get '/overriden_cb_error_handeling', {}, @headers
      
      expect(last_response.body).to eq(expected_body.to_json)
    end
  end
  
  describe :cb_multi_error do
    it "should return a CBMultiError response" do
      expected_body = {
        :errors => [
          {
            :type => "Error",
            :code => "400",
            :message => "CBError #1"
          },
          {
            :type => "Error",
            :code => "400",
            :message => "CBError #2"
          }
        ]
      }
      
      get '/cb_multi_error_handeling', {}, @headers
      
      expect(last_response.body).to eq(expected_body.to_json)
    end
  end

  describe :ruby_defined_errors do
    it 'should return NotImplemented response' do
      expected_body = {
        :errors => [
          {
            :type => 'No Implementation',
            :code => '500',
            :message => 'Method is Not Implemented'
          }
        ]
      }

      get '/not_implemented_error_raised', {}, @headers

      expect(last_response.body).to eq(expected_body.to_json)
    end
  end
end
