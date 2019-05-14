module RestBase
  module Test
    class TestApplication < RestBase::Application
      get '/messages', :version => 1 do
        @messages << "Test Message"
        "Messages Test"
      end
    end
  end
end