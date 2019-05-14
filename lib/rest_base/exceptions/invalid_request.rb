module RestBase
  module Exceptions
    class InvalidRequest < StandardError
      attr_reader :invalid_params
      
      def initialize(invalid_params)
        @invalid_params = invalid_params
        super "Invalid Request Format"
      end
    end
  end
end