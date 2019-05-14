module RestBase
  module Test
    class TestApplication < RestBase::Application     
      get '/', :version => 1 do
        {
          :gotten => "success"
        }
      end

      get '/', :version => 2 do
        {
          :gotten => "success 2"
        }
      end

      get '/empty', :version => 1 do
        ""
      end
      
      get '/nil', :version => 1 do
        nil
      end

      get '/noexplicitreturn', :version => 1 do
      end
      
      get '/nil_array', :version => 1 do
        [nil]
      end
      
      get '/created', :version => 1 do
        status 201
      end
      
      get '/nocontent', :version => 1 do
        status 204
      end
      
      get '/notmodified', :version => 1 do
        status 304
      end
      
      get '/created_with_body', :version => 1 do
        status 201
        { :created => true }
      end
      
      get '/render_erb', :version => 1 do
        erb :index
      end

      post '/', :version => 1 do
        {
          :posted => request_body
        }
      end

      put '/', :version => 1 do
        {
          :updated => request_body
        }
      end

      delete '/', :version => 1 do
        {
          :deleted => request_body
        }
      end
      
      delete '/nocontent', :version => 1 do
        status 204
      end

      get '/proto', :version => 1 do
        content_type :octetstream

        '0110010101010010010100101'
      end

      post '/proto', :version => 1 do

        status 201
      end
    end
  end
end