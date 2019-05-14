require 'spec_helper'

describe RestBase::Authentication::OauthAuthentication do
  describe :initialize do
    it "should initialize with a valid secret key" do
      expected_key = 'MySecretKey'
      target = RestBase::Authentication::OauthAuthentication.new(expected_key)

      expect(target.instance_variable_get(:@secret_key)).to eq(expected_key)
    end
  end

  describe :authorized? do
    it "should authorize if no secret key is provided" do
      target = RestBase::Authentication::OauthAuthentication.new('')
      @env = { 'HTTP_X_3SCALE_PROXY_SECRET_TOKEN' => 'MySecretKey' }
      request = Sinatra::Request.new @env
      expect(target.authorized?(request)).to be_truthy
    end

    it "should authorize the given key" do
      target = RestBase::Authentication::OauthAuthentication.new('MySecretKey')
      @env = { 'HTTP_X_3SCALE_PROXY_SECRET_TOKEN' => 'MySecretKey' }
      request = Sinatra::Request.new @env
      expect(target.authorized?(request)).to be_truthy
    end

    it "should not authorize the given key" do
      target = RestBase::Authentication::OauthAuthentication.new('MySecretKey')
      @env = { 'HTTP_X_3SCALE_PROXY_SECRET_TOKEN' => 'MyIncorrectSecretKey' }
      request = Sinatra::Request.new @env
      expect(target.authorized?(request)).to_not be_truthy
    end
    
    it "should authorize a authorization bypass url with an incorrect key" do
      target = RestBase::Authentication::OauthAuthentication.new('MySecretKey', { :auth_bypass_endpoints => ["/healthcheck", "/ping"] })
      @env = { 'HTTP_X_3SCALE_PROXY_SECRET_TOKEN' => 'MyIncorrectSecretKey' }
      request = Sinatra::Request.new @env
      allow(request).to receive(:url).and_return("/ping")
      expect(target.authorized?(request)).to be_truthy
    end
  end
end
