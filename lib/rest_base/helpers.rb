module RestBase
  module Helpers
    def self.included(base)
      base.class_eval do
        alias_method :original_error, :error
      
        def error(code, body=nil)
          env['errored.out'] = true
          
          original_error(code, body)
        end
      end
    end
  end
end
