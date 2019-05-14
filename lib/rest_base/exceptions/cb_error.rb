module RestBase
  module Exceptions
    class CBError < StandardError
      attr_accessor :type
      attr_accessor :code
      attr_accessor :status
      
      def initialize(error_hash = {})
        @type = error_hash[:type].nil? ? "Error" : error_hash[:type].to_s
        @code = error_hash[:code].nil? ? "400" : error_hash[:code].to_s
        @status = error_hash[:status].nil? ? 400 : error_hash[:status].to_i
        
        super error_hash[:message].nil? ? "Unkown Error" : error_hash[:message].to_s
      end
      
      def to_hash
        {
          :type => @type,
          :code => @code,
          :message => self.message
        }
      end
      
      def ==(other)
        return false unless other.is_a?(CBError)
        
        self.message == other.message && @type == other.type && @code == other.code && @status == other.status
      end
    end
  end
end