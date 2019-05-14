module Sinatra
  module Templates
    def erb(template, options = {}, locals = {}, &block)
      content_type :html
      render(:erb, template, options, locals, &block)
    end
  end
end