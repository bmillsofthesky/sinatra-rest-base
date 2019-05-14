module RestBase
  module Authentication
    
  end
end

Gem.find_files('rest_base/authentication/*.rb').each { |path| require path }
