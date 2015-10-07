[![Code Climate](https://codeclimate.com/github/pablo-co/cartodb-api/badges/gpa.svg)](https://codeclimate.com/github/pablo-co/cartodb-api) [![Test Coverage](https://codeclimate.com/github/pablo-co/cartodb-api/badges/coverage.svg)](https://codeclimate.com/github/pablo-co/cartodb-api/coverage)

# CartoDB::Api

CartoDB::Api is an API library for Ruby which acts as a wrapper for [CartoDB's API](https://cartodb.com/). All requests are built using a really simple fluid interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cartodb-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cartodb-api

## Usage

All requests need a configuration object. The first thing you need is to create one.

```ruby
configuration = CartoDB::Api:Configuration.new
```

The configuration defines all the details regarding the API requests.

* __timeout__: The request timeout in seconds (default: 30).
* __protocol__: The protocol that will be used for requests (default: https).
* __version__: The CartoDB API version that is going to be used (default: 1).
* __domain__: The domain or IP where the API can be found (default: cartodb.com).
* __api_key__: The CartoDB API key that will be used for authentication.
* __account__: The CartoDB account from which all requests are going to be made from.

```ruby
configuration.timeout = 15
configuration.protocol = 'https'
configuration.domain = 'customdomain.com'
configuration.api_key = '<Your API key>'
configuration.account = '<Account>'
```

__If you are trying to use the API available at cartodb.com the only configuration that you need to set is the api_key and account.__

To make this configuration the default for all requests:

```ruby
CartoDB::Api.default_configuration = configuration
```

For example, you could set the default configuration in an initializer file in your Rails app (config/initializers/cartodb.rb).

```ruby
configuration = CartoDB::Api:Configuration.new
configuration.api_key = ENV['CARTODB_API_KEY']
configuration.account = '<Account>'

CartoDB::Api.default_configuration = configuration
```

### Making requests

Once you have a configuration object you can create a request:

```ruby
cartodb = CartoDB::Api::Request.new(configuration)
```

If you have set a default configuration object there's no need of specifying one during creation:


```ruby
cartodb = CartoDB::Api::Request.new
```

Now you can make requests to the API resources specified in [CartoDB's API](https://cartodb.com/). Resource IDs are specified as arguments and the verbs: create, retrieve, update, and delete initiate the request.

For example to interact with the [import resource](http://docs.cartodb.com/cartodb-platform/import-api.html):

We define the request.
```ruby
cartodb = CartoDB::Api::Request.new
```

To get all imports.
```ruby
cartodb.imports.retrieve
```

To retrieve a specific import.
```ruby
cartodb.imports('<import id>').retrieve
```

You can also specify the params, headers and body when calling a CRUD method. For example:

To create a new import
```ruby
cartodb.imports.create(headers: {some_header: 'header_value'}, params: {some_param: 'param_value'})
```

All requests can be written inline without the need to create a Request object:

```ruby
CartoDB::Api.imports.retrieve
CartoDB::Api.imports('<import id>').retrieve
```

### Handling errors

There are 3 types of errors this gem can raise:

* __CartoDB::Api::InvalidConfiguration__: This error is raised when the configuration object is invalid or incomplete.
* __CartoDB::Api::Error__: This error is raised when there's an error related to the API request.
* __CartoDB::Api::ParsingError__: This error is raised when the request was successful but there was a problem parsing the JSON returned.

To retrieve more information about an error `CartoDB::Api::Error` and `CartoDB::Api::ParsingError` provide the following attributes: `title`, `details`, `body`, `raw_body` and `status_code`. Some may not be present depending on the nature of the error.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pablo-co/cartodb-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

There are also a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. These are detailed in the [Contributing guidelines](contributor-covenant.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

