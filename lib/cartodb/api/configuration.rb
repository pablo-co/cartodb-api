module CartoDB
  module Api
    class Configuration

      PROTOCOL = 'https'
      DOMAIN = 'cartodb.com'
      TIMEOUT = 30
      VERSION = 1

      # Public: Gets or sets the CartoDB account from which all requests are going to be made from.
      attr_accessor :account

      # Public: Gets or sets the CartoDB API key that will be used for authentication.
      attr_accessor :api_key

      # Public: Sets the protocol that will be used for requests
      attr_writer :protocol

      # Public: Sets the domain name for all HTTP requests
      attr_writer :domain

      # Public: Sets the request timeout
      attr_writer :timeout

      # Public: Sets the CartoDB API version
      attr_writer :version

      def protocol
        @protocol || PROTOCOL
      end

      def domain
        @domain || DOMAIN
      end

      def version
        @version || VERSION
      end

      def timeout
        @timeout || TIMEOUT
      end

      def base_url
        assert_configuration
        "#{protocol}://#{account}.#{domain}/api/"
      end

      def assert_configuration
        assert_attr(account, 'Account')
        assert_attr(api_key, 'API key')
        assert_in_options(protocol, %w{http https}, 'Protocol')
        assert_attr(domain, 'Domain')
        assert_attr(version, 'API version number')
      end

      def assert_attr(attr, attr_name)
        raise InvalidConfiguration.new("#{attr_name} should not be nil.") if attr.nil?
      end

      def assert_in_options(attr, options, attr_name)
        assert_attr(attr, attr_name)
        exception_message = "#{attr_name} is not a valid option. Should be any of: #{options.join(', ')}"
        raise InvalidConfiguration.new(exception_message) unless options.include? attr
      end

    end
  end
end
