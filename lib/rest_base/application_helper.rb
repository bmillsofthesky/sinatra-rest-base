require 'sinatra/base'

module RestBase
  class Application < Sinatra::Base
    def authenticated?
      authorized = true
      authorized = settings.authentication.authorized?(request) unless settings.authentication.nil?
      authorized
    end
    
    def base_api_url
      ENV['RACK_ENV'] == 'production' ? "https://api.careerbuilder.com/#{settings.api_route.sub(/^\//, '')}" : "https://wwwtest.api.careerbuilder.com/#{settings.api_route.sub(/^\//, '')}"
    end

    def raw_json(json)
      body = json
      @bypass_response_standardization = true
    end

    def has_version?(version)
      return true unless settings.header_versioning
      @env['HTTP_ACCEPT'] = "*/*" if @env['HTTP_ACCEPT'].nil?
      @env['HTTP_ACCEPT'].include?(version)
    end

    def get_version
      version = settings.active_version
      
      if has_version?("version=")
        matchdata = @env['HTTP_ACCEPT'].to_s.scan(/(version)=(\d*)/)
        found_version = matchdata[0][1].delete(',').to_i
        version = found_version if settings.active_version == found_version || settings.additional_versions.include?(found_version)
      end

      version
    end
    
    def set_header_version
      if has_version?("version=")
        @env['HTTP_ACCEPT'] = @env['HTTP_ACCEPT'].downcase.sub(/;version=\d*/, ";version=#{@request_version}")
      else
        @env['HTTP_ACCEPT'] = @env['HTTP_ACCEPT'].downcase + ";version=#{@request_version}"
      end
    end
    
    def set_api_version   
      @env['sinatra.accept'] = nil
      @request_version = get_version
      set_header_version
    end

    def set_request_body
      read_body = request.body.read

      begin
        if read_body.empty?
          @request_body = {}
        elsif request.media_type.downcase == 'text/xml'
          @request_body = Hash.from_xml(read_body)
          @request_body = Hash[@request_body.map { |k, v| [k.to_sym, v] }]
          @request_body = @request_body[:request]
        elsif request.media_type.downcase == 'application/octet-stream'
          @request_body = read_body
        else
          @request_body = JSON.parse(read_body, :symbolize_names => true)
        end
      rescue
        raise StandardError.new("Invalid Request Body")
      end
    end

    def setup_pagination
      @pagination = nil
    end

    def setup_forensics
      @forensics = []
    end

    def setup_messages
      @messages = []
    end

    def add_pagination(page, page_size, total)
      @pagination = {
        :page => page,
        :page_size => page_size,
        :total => total
      }
    end

    def add_forensics_to_response?
      !@env['Forensics'].nil? && @env['Forensics'].downcase == 'true'
    end

    def set_response
      content_type :json
      content_type :xml if !request.accept?('*/*') && request.accept?('text/xml')

      response_hash = {}

      if response.body.nil?
        # empty string or nothing explicitly returned from endpoint
        response_hash[:data] = ''
      elsif response.body.empty?
        # [] or explicit nil returned from endpoint
        response_hash[:data] = nil
      elsif response.body.length == 1
        # only one thing in the body array
        if response.body[0].instance_of? String
          # and its a string
          response_hash[:data] = response.body[0]
        else
          response_hash[:data] = response.body
        end
      else
        response_hash[:data] = response.body
      end

      unless @pagination.nil? || @pagination.empty?
        response_hash[:page] = @pagination[:page]
        response_hash[:page_size] = @pagination[:page_size]
        response_hash[:total] = @pagination[:total]
      end

      response_hash[:messages] = @messages unless @messages.nil? || @messages.empty?
      response_hash[:forensics] = @forensics if add_forensics_to_response? && !(@forensics.nil? || @forensics.empty?)
      response.headers['Content-Type'] += ";version=#{@request_version}" if settings.header_versioning

      if empty_body_status_code? && (response.body.nil? || (response.body.respond_to?(:empty?) && response.body.empty?))
        response.body = ''
      elsif response.headers['Content-Type'].start_with? 'application/xml;'
        response.body = response_hash.to_xml(:root => :response)
      else
        response.body = response_hash.to_json
      end
    end

    def set_error_response(errors)
      content_type :json
      content_type :xml if !request.accept?('*/*') && request.accept?('text/xml')

      errors = [errors] unless errors.is_a?(Array)

      response_hash = {}
      response_hash[:errors] = errors
      response_hash[:messages] = @messages unless @messages.nil? || @messages.empty?
      response_hash[:forensics] = @forensics if add_forensics_to_response? && !(@forensics.nil? || @forensics.empty?)
      response.headers['Content-Type'] += ";version=#{@request_version}"

      if response.headers['Content-Type'].start_with? 'application/xml;'
        response.body = response_hash.to_xml(:root => :response)
      else
        response.body = response_hash.to_json
      end
      
      env['errored.out'] = true
    end

    def empty_body_status_code?
      empty_body_status_codes = [201, 204, 304]
      !response.nil? && empty_body_status_codes.include?(response.status)
    end

    def header_is_bypassable_type?(response)
      [%r{text\/html},
       %r{text\/css},
       %r{application\/javascript},
       %r{image\/.*},
       %r{application\/x-font-ttf},
       %r{application\/octet-stream},
       %r{application\/x-font-truetype}].any? { |content_type| response.header["Content-Type"].match(content_type) }
    end

    def check_cors_overrides()
      raise StandardError.new('CORS Allowed Methods must be an Array of Strings') if settings.allowed_methods.nil? || settings.allowed_methods.empty? || !settings.allowed_methods.is_a?(Array)

      raise StandardError.new('CORS Allowed Headers must be an Array of Strings') if settings.allowed_headers.nil? || settings.allowed_headers.empty? || !settings.allowed_headers.is_a?(Array)

      raise StandardError.new('CORS Allowed Origins must be a valid DNS') if settings.allowed_origin.nil? || settings.allowed_origin.empty?
    end

    def setup_cors_pre_flight(response)
      response.headers['Allow'] = settings.allowed_methods.join(', ').upcase
      response.headers['Access-Control-Allow-Headers'] = settings.allowed_headers.join(', ')
      response.headers['Access-Control-Allow-Origin'] = settings.allowed_origin
      response.headers.delete('Access-Control-Allow-Origin')
    end

    def setup_cors_headers
      headers 'Access-Control-Allow-Origin' => settings.allowed_origin,
              'Access-Control-Allow-Methods' => settings.allowed_methods.map(&:upcase),
              'Access-Control-Allow-Headers' => settings.allowed_headers
    end
  end
end