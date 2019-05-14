module RestBase
  module Exceptions
    class CBMultiError < StandardError
      attr_accessor :type
      attr_accessor :code
      attr_accessor :messages
      attr_accessor :status
      
      def initialize(error_hash = {})
        @type = error_hash[:type].nil? ? "Error" : error_hash[:type].to_s
        @code = error_hash[:code].nil? ? "400" : error_hash[:code].to_s
        @status = error_hash[:status].nil? ? 400 : error_hash[:status].to_i
        @messages = error_hash[:errors].nil? ? [] : error_hash[:errors]
        
        super "Multiple Errors of type #{@type} with code #{code} occured:\n#{@messages.join(",\n")}"
      end
      
      def errors
        multi_errors = []
        @messages.each { |message|
          multi_errors << {
            :type => @type,
            :code => @code,
            :message => message
          }
        }
        
        multi_errors
      end
      
      def to_a
        errors
      end
      
      def ==(other)
        return false unless other.is_a?(CBMultiError)
        
        self.message == other.message && @type == other.type && @code == other.code && @messages == other.messages && @status == other.status
      end
    end
  end
end