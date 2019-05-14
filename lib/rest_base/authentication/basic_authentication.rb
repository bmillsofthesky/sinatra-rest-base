require 'rest_base/authentication/authentication_base'

module RestBase
  module Authentication
    class BasicAuthentication < AuthenticationBase
      def initialize(keys, options = {})
        @valid_keys = keys
        super options
      end

      def authorized?(request)
        authorized = true
        authorized = (is_auth_bypass_endpoint? request) || @valid_keys.include?(request.env['HTTP_AUTHORIZATION']) unless @valid_keys.length == 0
        authorized
      end
    end
  end
end