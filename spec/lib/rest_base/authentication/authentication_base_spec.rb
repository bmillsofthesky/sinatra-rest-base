require 'spec_helper'

describe RestBase::Authentication::AuthenticationBase do
  describe :authorized? do
    it "should always be true" do
      target = RestBase::Authentication::AuthenticationBase.new

      expect(target.authorized?(nil)).to be_truthy
    end
  end

  describe :is_auth_bypass_endpoint? do
    it "should return false if the url is not in the request array" do
      target = RestBase::Authentication::AuthenticationBase.new({ :auth_bypass_endpoints => ["/healthcheck"] })
      @env =   {:base_url => '/'}
      request = Sinatra::Request.new @env
      allow(request).to receive(:url).and_return("example.com/ping")
      expect(target.is_auth_bypass_endpoint?(request)).to eq false
    end
  end
  
  describe :is_auth_bypass_endpoint? do
    it "should return true if the url is /ping" do
      target = RestBase::Authentication::AuthenticationBase.new({ :auth_bypass_endpoints => ["/healthcheck", "/ping"] })
      @env =   {:base_url => '/'}
      request = Sinatra::Request.new @env
      allow(request).to receive(:url).and_return("example.com/ping")
      expect(target.is_auth_bypass_endpoint?(request)).to eq true
    end
  end
end