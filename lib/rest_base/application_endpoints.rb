require 'sinatra/base'

module RestBase
  class Application < Sinatra::Base
    options '*' do
      setup_cors_pre_flight(response)

      200
    end
  end
end