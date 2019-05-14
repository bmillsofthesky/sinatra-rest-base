require 'rest_base/authentication/authentication_base'

module RestBase
  module Authentication
    class OauthAuthentication < AuthenticationBase
      attr_reader :secret_key
      
      def initialize(key, options = {})
        @secret_key = key
        super options
      end

      def authorized?(request)
        authorized = true
        authorized = (is_auth_bypass_endpoint? request) || request.env['HTTP_X_3SCALE_PROXY_SECRET_TOKEN'] == @secret_key unless @secret_key.nil? || @secret_key.length == 0
        authorized
      end
    end
  end
end