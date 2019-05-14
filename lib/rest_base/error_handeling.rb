require 'sinatra/base'
require 'rest_base/exceptions'

module RestBase
  class Application < Sinatra::Base
    #region Status base Error Handling
    error 400 do
      status 400

      message = try_get_error_message_from_body("Error")

      error_message = {
        :type => "Error",
        :code => "400",
        :message => message
      }

      set_error_response(error_message)
    end

    error 401 do
      status 401

      message = try_get_error_message_from_body("Unauthorized Access")

      error_message = {
        :type => "Unauthorized",
        :code => "401",
        :message => message
      }

      set_error_response(error_message)
    end

    error 404 do
      status 404

      message = try_get_error_message_from_body('Not Found')

      error_message = {
        :type => "Not Found",
        :code => "404",
        :message => message
      }

      set_error_response(error_message)
    end

    error 500..600 do
      status response.status.to_i

      message = try_get_error_message_from_body('Internal Error')

      error_message = {
        :type => "Error",
        :code => response.status.to_s,
        :message => message
      }

      set_error_response(error_message)
    end
    #endregion

    #region Custom Error Handling
    error Sinatra::NotFound do
      status 404
      
      error = {
        :type => "Not Found",
        :code => "404",
        :message => "Endpoint Not Found"
      }
      
      set_error_response(error)
    end
    
    error RestBase::Exceptions::CBError do
      cur_error = env['sinatra.error']
      status cur_error.status      
      
      set_error_response(cur_error.to_hash)
    end
    
    error RestBase::Exceptions::CBMultiError do
      cur_error = env['sinatra.error']
      status cur_error.status
      
      set_error_response(cur_error.to_a)
    end
    
    error RestBase::Exceptions::InvalidRequest do
      status 400
      
      cur_error = env["sinatra.error"]
      errors = []

      cur_error.invalid_params.each { |param, message|
        errors << {
          :type => cur_error.message,
          :code => "400",
          :message => "#{param.to_s} is not valid: #{message}"
        }
      }

      set_error_response(errors)
    end

    error NotImplementedError do
      status 500

      cur_error = env['sinatra.error']

      error = {
        :type => 'No Implementation',
        :code => '500',
        :message => cur_error.message
      }

      set_error_response(error)
    end
    
    error StandardError do
      status 500
      
      cur_error = env["sinatra.error"]
      
      error = {
        :type => "Error",
        :code => "500",
        :message => cur_error.message
      }
      
      set_error_response(error)
    end
    #endregion

    #region DEFAULT Error Handling
    error do
      status response.status.to_i

      message = try_get_error_message_from_body('Internal Error')

      error_message = {
        :type => "Error",
        :code => response.status.to_s,
        :message => message
      }

      set_error_response(error_message)
    end
    #endregion

    def try_get_error_message_from_body(default_message = nil)
      message = default_message
      message = response.body unless response.body.nil? || response.body.empty?
      message = message[0] if message.is_a?(Array) && message.length == 1 && message[0].is_a?(String)

      return message.to_json if message.is_a?(Array) || message.is_a?(Hash)

      message.to_s
    end
  end
end