module RestBase
  module Test
    class TestApplication < RestBase::Application
      get '/pagination', :version => 1 do
        add_pagination(1,1,1)
        "Pagination Test"
      end
    end
  end
end