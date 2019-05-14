require 'sinatra/base'
require 'sinatra/cross_origin'
require 'json'
require 'active_support'
require 'active_support/core_ext/hash'
require 'rest_base/authentication'
require 'rest_base/helpers'
require 'newrelic_rpm' unless ENV['NEW_RELIC_LICENSE'].blank?

module RestBase
  class Application < Sinatra::Base
    include Sinatra::Helpers
    include RestBase::Helpers
    
    attr_reader :request_body
    attr_reader :request_version
    attr_reader :pagination
    attr_reader :forensics
    attr_reader :messages
    attr_reader :bypass_response_standardization

    register Sinatra::CrossOrigin
    Tilt.register Tilt::ERBTemplate, 'html.erb'

    configure do
      disable :raise_errors
      disable :show_exceptions

      set :allowed_methods, ['*']
      set :allowed_headers, ['*']
      set :allowed_origin, '*'

      set :active_version, 1
      set :additional_versions, []
      set :api_route, ''
      set :authentication, RestBase::Authentication::BasicAuthentication.new([])
      enable :header_versioning
      mime_type :octetstream, 'application/octet-stream'
    end

    set(:version) do |value|
      condition do
        if has_version?("version=#{value}")
          @request_version = value
          return true
        end
        
        false
      end
    end
    
    set(:method) do |method|
      condition do
        request.request_method.downcase.to_sym == method.to_s.downcase.to_sym
      end
    end

    before do
      status 200

      check_cors_overrides

      set_api_version if settings.header_versioning
      set_request_body
      setup_forensics
      setup_messages
      setup_cors_headers

      error 401 unless authenticated?

      if ENV['MAINTENANCE_MODE'].to_s.downcase == 'true'
        headers 'Retry-After' => '600'
        @messages << 'Service in Maintenance'
        halt 200
      end
    end

    after do
      unless @bypass_response_standardization || env['errored.out'] || (!response.header["Content-Type"].nil? && header_is_bypassable_type?(response))
        is_array_of_one = response.body.is_a?(Array) && response.body.length == 1
        response.body = nil if is_array_of_one && response.body[0].respond_to?(:empty?) && response.body[0].empty?
        set_response
      end
      
      if env['errored.out'] && env['sinatra.error'].nil? && response.status < 400
        set_error_response({
          :type => "Error",
          :code => response.status.to_s,
          :message => try_get_error_message_from_body('Something Bad Happend')
        })
      end
    end
  end
end