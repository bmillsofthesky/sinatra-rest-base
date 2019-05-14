module RestBase
  module Test
    class TestApplication < RestBase::Application
      configure do
        enable :raise_errors
        set :api_route, '/core'
        set :active_versions, [1,2]
        set :authentication, RestBase::Authentication::BasicAuthentication.new(['key1', 'key2'])
        enable :header_versioning
        set :views, Proc.new { File.join(root, '../../spec/views') }
      end
      
      before '/method_filter', :method => :get do
        @method_response = []
        @method_response << "Hit Before Filter"
      end
      
      get '/method_filter' do
        @method_response << "Response Filtered"
        @method_response
      end
      
      put '/method_filter' do
        @method_response = []
        @method_response << "Response Filtered"
        
        headers['Location'] = base_api_url
        
        @method_response
      end
    end
  end
end