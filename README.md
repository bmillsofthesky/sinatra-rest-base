# Rest
Core base for quick configuration of Sinatra for RESTful Services

#### What Does the Core Cover
* Adherence to [API Standards] (https://github.com/cbdr/sinatra-rest-base-cb/wiki/API-Standards)
* Basic Configuration
  * Storing the IO String Request Body into a global hash 'request_body'
  * Processing the response body into the proper accepted mime type (application/json, text/xml, ect.) depending on the HTTP_ACCEPT header.
      * Defaults to application/json
  * Processing the version of the application being accessed via HTTP_ACCEPT header
* Basic Error Handeling
  * Handles Authentication Errors, StandardError, Error status codes 400..510
  * Provides Basic Error Classes Implementations
* Simple authentication setup
  * Provides a base authentication class to inherit from and create a quick authentication process.
  * Provides an easy authentication setup through the configuration setup of Sinatra.
* Cross-Origin Resource Sharing (CORS) Enabled
  * Provides easy configuration of 'Access-Control-Allow-Origin', 'Access-Control-Allow-Methods', 'Access-Control-Allow-Headers'

## Installation
Add this line to your application's Gemfile:
```
:source => 'Gemfury Url'
```

Add this line to you application's .gemspec:
```
spec.add_dependency 'sinatra-rest-base-cb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra-rest-base-cb

## Usage

#### Setting Up the Application 

Normal Sinatra Appication inherit from either Sinatra::Application or Sinatra::Base. 
With sinatra-rest-base you just need to inherit from RestBase::Application.

In your main application file, do the following:

```ruby
require 'rest_base'

class SinatraApp < RestBase::Application
  get '/' do
     {
       :result => "This is so easy now!"
     }
   end
end
```

Bam, that easy!

## [Documentation Wiki] (https://github.com/cbdr/sinatra-rest-base-cb/wiki)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
