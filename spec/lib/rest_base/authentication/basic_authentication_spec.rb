require 'spec_helper'

describe RestBase::Authentication::BasicAuthentication do
  describe :initialize do
    it "should initialize with valid keys" do
      expected_keys = ['key1', 'key2']
      target = RestBase::Authentication::BasicAuthentication.new(expected_keys)

      expect(target.instance_variable_get(:@valid_keys)).to eq(expected_keys)
    end
  end

  describe :authorized? do
    it "should authorized if empty valid array" do
      target = RestBase::Authentication::BasicAuthentication.new([])
      @env = { 'HTTP_AUTHORIZATION' => 'key1' }
      request = Sinatra::Request.new @env
      expect(target.authorized?(request)).to be_truthy
    end

    it "should authorize the given key" do
      target = RestBase::Authentication::BasicAuthentication.new(['key1', 'key2'])
      @env = { 'HTTP_AUTHORIZATION' => 'key1' }
      request = Sinatra::Request.new @env
      expect(target.authorized?(request)).to be_truthy
    end

    it "should not authorize the given key" do
      target = RestBase::Authentication::BasicAuthentication.new(['key1', 'key2'])
      @env = { 'HTTP_AUTHORIZATION' => 'key3' }
      request = Sinatra::Request.new @env
      expect(target.authorized?(request)).to_not be_truthy
    end
    
    it "should authorize an authorization bypass url with an incorrect key" do
      target = RestBase::Authentication::BasicAuthentication.new(['key1', 'key2'], { :auth_bypass_endpoints => ["/healthcheck", "/ping"] })
      @env = { 'HTTP_AUTHORIZATION' => 'key3' }
      request = Sinatra::Request.new @env
      allow(request).to receive(:url).and_return("/ping")
      expect(target.authorized?(request)).to be_truthy
    end
  end
end
