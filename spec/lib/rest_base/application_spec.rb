require 'spec_helper'

describe RestBase::Application do
  before(:each) do
    @headers = { 'HTTP_AUTHORIZATION' => 'key1' }
  end

  describe :version do
    it "should set the version to latest when not given" do
      expected_version = "version=1"

      get '/', {}, @headers

      expect(last_request.env["HTTP_ACCEPT"].include? expected_version).to be_truthy
      expect(last_response.headers["Content-Type"].include? expected_version).to be_truthy
    end
    
    it "should set the version to latest when given non-existing" do
      expected_version = "version=1"
      @headers['HTTP_ACCEPT'] = "application/json;version=100"

      get '/', {}, @headers

      expect(last_request.env["HTTP_ACCEPT"].include? expected_version).to be_truthy
      expect(last_response.headers["Content-Type"].include? expected_version).to be_truthy
    end

    it "should get the version 1 version" do
      expected_version = "version=1"
      @headers['HTTP_ACCEPT'] = "application/json;#{expected_version}"

      get '/', {}, @headers

      expect(last_request.env["HTTP_ACCEPT"].include? expected_version).to be_truthy
      expect(last_response.headers["Content-Type"].include? expected_version).to be_truthy
      expect(last_response.body).to eq({:data => { :gotten => "success" }}.to_json)
    end

    it "should get the version 2 version" do
      expected_version = "version=2"
      @headers['HTTP_ACCEPT'] = expected_version

      get '/', {}, @headers

      expect(last_request.env["HTTP_ACCEPT"].include? expected_version).to be_truthy
      expect(last_response.headers["Content-Type"].include? expected_version).to be_truthy
      expect(last_response.body).to eq({:data => { :gotten => "success 2" }}.to_json)
    end
  end

  describe :method do
    it "should go through the before filter" do
      get '/method_filter', {}, @headers

      expect(last_response.body).to eq({:data => ["Hit Before Filter", "Response Filtered"]}.to_json)
    end

    it "should not go through the before filter" do
      put '/method_filter', {}, @headers

      expect(last_response.body).to eq({:data => "Response Filtered"}.to_json)
      expect(last_response.headers["Location"]).to eq("https://wwwtest.api.careerbuilder.com/core")
    end
  end

  describe :authorization do
    it "should try to authorize" do
      get '/', {}, @headers
    end
  end

  describe :maintenance do
    it "should return a 200 with correct message" do
      ENV['MAINTENANCE_MODE'] = 'TRUE'
      get '/', {}, @headers

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({:data => nil, :messages => ["Service in Maintenance"]}.to_json)
      ENV['MAINTENANCE_MODE'] = ""
    end
  end
  describe :status do
    it "should return status code 200" do
      get '/', {}, @headers

      expect(last_response.status).to eq(200)
    end
  end

  describe :empty_response do
    it "should return an empty string response" do
      get '/empty', {}, @headers

      expect(last_response.body).to eq({ :data => "" }.to_json)
    end
    
    it "should return an nil data response" do
      get '/nil', {}, @headers
      
      expect(last_response.body).to eq({ :data => nil }.to_json)
    end
    
    it "should return an nil array entry response" do
      get '/nil_array', {}, @headers
      
      expect(last_response.body).to eq({ :data => [nil] }.to_json)
    end

    it "should return null for no explicit return" do
      get '/noexplicitreturn', {}, @headers

      expect(last_response.body).to eq({ :data => nil }.to_json)
    end
  end

  describe :no_content do
    it "should return a no content response with empty body" do
      get '/nocontent', {}, @headers

      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_empty
    end

    it "should return a created response with empty body" do
      get '/created', {}, @headers

      expect(last_response.status).to eq(201)
      expect(last_response.body).to be_empty
    end

    it "shoud return a created response with body" do
      get '/created_with_body', {}, @headers

      expect(last_response.status).to eq(201)
      expect(last_response.body).to eq({:data => {:created => true}}.to_json)
    end

    it "should return a not modified response with empty body" do
      get '/notmodified', {}, @headers

      expect(last_response.status).to eq(304)
      expect(last_response.body).to be_empty
    end

    it "should delete and return a no content response with empty body" do
      delete '/nocontent', {}, @headers

      expect(last_response.status).to eq(204)
      expect(last_response.body).to be_empty
    end
  end
  
  describe :pagination do
    before :each do
      @expected_hash = {:data => "Pagination Test", :page => 1, :page_size => 1, :total => 1}
    end
    
    it "should add pagination to request" do
      get '/pagination', {}, @headers
      
      expect(last_response.body).to eq(@expected_hash.to_json)
    end
  end
  
  describe :messages do
    before :each do
      @expected_hash = { :data => "Messages Test", :messages => ["Test Message"]}
    end
    
    it "should add messages to request" do
      get '/messages', {}, @headers
      
      expect(last_response.body).to eq(@expected_hash.to_json)
    end
  end

  describe :forensics do
    before(:each) do
      @expected_hash = {:data => "Forensics Test", :forensics => ["Added Forensics"]}
      @headers['Forensics'] = 'TRUE'
    end

    it "should add forensics to body" do
      get '/forensics', {}, @headers

      expect(last_response.body).to eq(@expected_hash.to_json)
    end

    it "should not add forensics to body" do
      @headers.delete('Forensics')
      get '/forensics', {}, @headers

      @expected_hash.delete(:forensics)
      expect(last_response.body).to eq(@expected_hash.to_json)
    end

    it "should not add nil/empty forensics to body" do
      get '/forensics_empty', {}, @headers

      @expected_hash.delete(:forensics)
      expect(last_response.body).to eq(@expected_hash.to_json)
    end
  end
  
  describe :erb do
    before(:each) do
      @expected_body = "<h1>Sinatra Rest Base</h1>"
    end
    
    it "should render the erb index" do
      get '/render_erb', {}, @headers
      
      expect(last_response.body).to eq(@expected_body)
    end
  end

  describe :json do
    before(:each) do
      @posted_body =  { :success => true }

      @expected_hash = {:data => { :posted => @posted_body }}
    end

    it "should get json" do
      @expected_hash = {:data => { :gotten => "success" }}

      get '/', {}, @headers

      expect(last_response.body).to eq(@expected_hash.to_json)
    end

    it "should set the request body to json" do
      @headers['CONTENT_TYPE'] = 'application/json'

      post '/', @posted_body.to_json, @headers

      expect(last_response.body).to eq(@expected_hash.to_json)
    end

    it "should post xml and return json" do
      @headers['CONTENT_TYPE'] = 'text/xml'
      post '/', @posted_body.to_xml(:root => :request), @headers

      expect(last_response.body).to eq(@expected_hash.to_json)
    end

    it "should post empty json and return json" do
      post '/', "", @headers

      @expected_hash[:data][:posted] = {}
      expect(last_response.body).to eq(@expected_hash.to_json)
    end

    it "should post json with json string as body" do
      post '/', @posted_body.to_json, @headers

      expect(last_response.body).to eq(@expected_hash.to_json)
    end

    it "should fail with bad json" do
      post '/', "}", @headers

      @expected_hash.delete(:data)
      @expected_hash[:errors] = [
        {
          :type => "Error",
          :code => "500",
          :message => "Invalid Request Body"
        }
      ]

      expect(last_response.status).to eq(500)
      expect(last_response.body).to eq(@expected_hash.to_json)
    end
  end

  describe :octetstream do
    before(:each) do
      @posted_body = '0110010101010010010100101'

    end

    it "should set the request body to an octet stream" do
      @headers['CONTENT_TYPE'] = 'application/octet-stream'
      @headers['HTTP_ACCEPT'] = 'application/octet-stream'
      post '/proto', @posted_body, @headers

      expect(last_response.status).to eq(201)
      expect(last_response.body).to be_empty

    end

    it "should set the response body to an octet stream" do
      @headers['HTTP_ACCEPT'] = 'application/octet-stream'
      get '/proto', {}, @headers

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq(@posted_body)
    end
  end

  describe :xml do
    before(:each) do
      @posted_body =  { :success => true }

      @expected_hash = {:data => { :posted => @posted_body }}
    end

    it "should get xml" do
      @headers['HTTP_ACCEPT'] = 'text/xml'
      @expected_hash = {:data => { :gotten => 'success'} }

      get '/', {}, @headers

      expect(last_response.body).to eq(@expected_hash.to_xml(:root => :response))
    end

    it "should set the request body to xml" do
      @headers['CONTENT_TYPE'] = 'text/xml'
      @headers['HTTP_ACCEPT'] = 'text/xml'
      post '/', @posted_body.to_xml(:root => :request), @headers

      expect(last_response.body).to eq(@expected_hash.to_xml(:root => :response))
    end

    it "should post json and return xml" do
      @headers['CONTENT_TYPE'] = 'application/json'
      @headers['HTTP_ACCEPT'] = 'text/xml'
      post '/', @posted_body.to_json, @headers

      expect(last_response.body).to eq(@expected_hash.to_xml(:root => :response))
    end

    it "should post json with json string as body" do
      @headers['CONTENT_TYPE'] = 'text/xml'
      @headers['HTTP_ACCEPT'] = 'text/xml'
      post '/', @posted_body.to_xml(:root => :request), @headers

      expect(last_response.body).to eq(@expected_hash.to_xml(:root => :response))
    end

    it "should fail on bad xml" do
      @headers['CONTENT_TYPE'] = 'text/xml'
      @headers['HTTP_ACCEPT'] = 'text/xml'

      @expected_hash.delete(:data)
      @expected_hash[:errors] = [
        { 
          :type => "Error",
          :code => "500",
          :message => "Invalid Request Body"
        }
      ]

      post '/', "<BadXML>", @headers

      expect(last_response.status).to eq(500)
      expect(last_response.body).to eq(@expected_hash.to_xml(:root => :response))
    end
  end
end
