require 'spec_helper'

describe RestBase::Application do
  before(:each) do
    @expected_body = {
      :errors => []
    }
    
    @headers = { 'HTTP_AUTHORIZATION' => 'key1' }  
  end
  
  describe :error_default_handler do
    it "should create a error response based on the body" do
      @expected_body[:errors] << {
        :type => "Error",
        :code => "400",
        :message => "This is the default error handler"
      }
      
      get '/default_error_handeling', {}, @headers
      
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq(@expected_body.to_json)
    end
    
    it "should create a hashed error response based on the body" do
      @expected_body[:errors] << {
        :type => "Error",
        :code => "400",
        :message => { :error => "This is the hashed error handler" }.to_json
      }
      
      get '/hashed_error_handeling', {}, @headers
      
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq(@expected_body.to_json)
    end
  end
  
  describe :successful_errors do
    it "should create a error response based on the body" do
      @expected_body[:errors] << {
        :type => "Error",
        :code => "200",
        :message => "It was a successful error"
      }
      
      get '/successful_error', {}, @headers
      
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(@expected_body.to_json)
    end
  end
  
  describe :error_404 do
    it "should provide standard 404 error" do
      @expected_body[:errors] << {
        :type => "Not Found",
        :code => "404",
        :message => "Not Found"
      }
      
      get '/notfound', {}, @headers
      
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq(@expected_body.to_json)
    end
  end
  
  describe :error_401 do
    before (:each) do
      @expected_body[:errors] << {
        :type => "Unauthorized",
        :code => "401",
        :message => "Unauthorized Access"
      }
    end
    
    it "should create an unauthorized error in json" do
      get '/unauthorized', {}, @headers
      
      expect(last_response.status).to eq(401)
      expect(last_response.body).to eq(@expected_body.to_json)
    end
    
    it "shoud create an unauthorized error in xml" do
      @headers['HTTP_ACCEPT'] = 'text/xml'
      get '/unauthorized', {}, @headers
      
      expect(last_response.status).to eq(401)
      expect(last_response.body).to eq(@expected_body.to_xml(:root => :response))
    end
  end
  
  describe :error_500 do
    it "should create an array of errors with the error message in json when halted" do
      @expected_body[:errors] << {
        :type => "Error",
        :code => "500",
        :message => "Internal Error"
      }
      
      get '/internal_error', {}, @headers
      
      expect(last_response.status).to eq(500)
      expect(last_response.body).to eq(@expected_body.to_json)
    end
    
    it "should create an array of errors with the error message in xml when halted" do
      @expected_body[:errors] << {
        :type => "Error",
        :code => "500",
        :message => "Internal Error"
      }
      
      @headers['HTTP_ACCEPT'] = 'text/xml'
      get '/internal_error', {}, @headers
      
      expect(last_response.status).to eq(500)
      expect(last_response.body).to eq(@expected_body.to_xml(:root => :response))
    end
    
    it "should create an array of errors with the error message in json when raised" do
      @expected_body[:errors] << {
        :type => "Error",
        :code => "500",
        :message => "Raised Internal Error"
      }
      
      get '/internal_error_raised', {}, @headers
      
      expect(last_response.status).to eq(500)
      expect(last_response.body).to eq(@expected_body.to_json)
    end
    
    it "should create an array of errors with the error message in xml when raised" do
      @expected_body[:errors] << {
        :type => "Error",
        :code => "500",
        :message => "Raised Internal Error"
      }
      
      @headers['HTTP_ACCEPT'] = 'text/xml'
      get '/internal_error_raised', {}, @headers
      
      expect(last_response.status).to eq(500)
      expect(last_response.body).to eq(@expected_body.to_xml(:root => :response))
    end
  end
end