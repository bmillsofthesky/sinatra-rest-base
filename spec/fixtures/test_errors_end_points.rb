module RestBase
  module Test
    class TestApplication < RestBase::Application
      OverriddenCBError = Class.new(RestBase::Exceptions::CBError)
      
      get '/invalid_request', :version => 1 do
        param_errors = {
          :param1 => "Must be a String",
          :param2 => "Must be an Integer"
        }

        raise RestBase::Exceptions::InvalidRequest.new(param_errors)
      end
      
      get '/successful_error', :version => 1 do
        error 200, "It was a successful error"
      end
      
      get '/raise_successful_error', :version => 1 do
        raise RestBase::Exceptions::CBError.new({:type => "CBError", :status => 200, :code => "400", :message => "A CBError Message"})
      end

      get '/unauthorized', :version => 1 do
        error 401
      end
      
      get '/notfound', :version => 1 do
        error 404
      end

      get '/internal_error', :version => 1 do
        error 500
      end

      get '/internal_error_raised', :version => 1 do
        raise StandardError.new("Raised Internal Error")
      end

      get '/not_implemented_error_raised', :version => 1 do
        raise NotImplementedError.new('Method is Not Implemented')
      end

      get '/default_error_handeling', :version => 1 do
        error 400, "This is the default error handler"
      end
      
      get '/hashed_error_handeling', :version => 1 do
        error 400, { :error => "This is the hashed error handler" }
      end
    
      get '/cb_error_handeling', :version => 1 do
        raise RestBase::Exceptions::CBError.new({:type => "CBError", :code => "407", :message => "A CBError Message"})
      end
      
      get '/overriden_cb_error_handeling', :version => 1 do
        raise OverriddenCBError.new({:message => "An Overridden CBError Message"})
      end
      
      get '/cb_multi_error_handeling', :version => 1 do
        errors = {
          :code => "400",
          :status => 400,
          :errors => [ "CBError #1", "CBError #2" ]
        }
        
        raise RestBase::Exceptions::CBMultiError.new(errors)
      end
      
      get '/cb_error_with_messages', :version => 1 do
        @messages << "Test Message"
        raise RestBase::Exceptions::CBError.new({:type => "Error", :code => "400", :message => "Error"})
      end
      
      get '/cb_error_with_forensics', :version => 1 do
        @forensics << "Test Forensic"
        raise RestBase::Exceptions::CBError.new({:type => "Error", :code => "400", :message => "Error"})
      end
    end
  end
end