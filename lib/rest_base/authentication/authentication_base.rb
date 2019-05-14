module RestBase
  module Authentication
    class AuthenticationBase
      def initialize (options = {})
        @auth_bypass_endpoints = options[:auth_bypass_endpoints]        
      end
      
      def authorized?(request)
        true
      end
      
      def is_auth_bypass_endpoint? request
        !@auth_bypass_endpoints.nil? && (@auth_bypass_endpoints.any? { |x| request.url.include? x})
      end
    end
  end
end