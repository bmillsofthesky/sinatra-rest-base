module RestBase
  module Test
    class TestApplication < RestBase::Application
      get '/forensics', :version => 1 do
        @forensics << "Added Forensics"
        "Forensics Test"
      end
      
      get '/forensics_empty', :version => 1 do
        "Forensics Test"
      end
    end
  end
end