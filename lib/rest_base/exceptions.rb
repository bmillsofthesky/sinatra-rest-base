module RestBase
  module Exceptions
  end
end

Gem.find_files('rest_base/exceptions/*.rb').each { |path| require path }
