module CartoDB
  module Api
    class Request
      extend Forwardable

      attr_accessor :configuration

      def_delegators :configuration, [:protocol, :domain, :api_key,
                                      :account, :base_url, :version,
                                      :timeout]

      def initialize(configuration)
        self.configuration = configuration
        reset
      end

      def method_missing(method, *args)
        @path_steps << method.downcase
        @path_steps << args if args.length > 0
        @path_steps.flatten!
        self
      end

      def create(params = nil, headers = nil, body = nil)
        make_request(:post, params, headers, body)
      end

      def update(params = nil, headers = nil, body = nil)
        make_request(:patch, params, headers, body)
      end

      def retrieve(params = nil, headers = nil)
        make_request(:get, params, headers)
      end

      def delete(params = nil, headers = nil)
        make_request(:delete, params, headers)
      end

      protected

      def reset
        @path_steps = []
      end

      def client
        Faraday.new(url: url) do |client|
          client.params['api_key'] = api_key
          client.response :raise_error
          client.adapter Faraday.default_adapter
        end
      end

      def make_request(method, params = nil, headers = nil, body = nil)
        begin
          response = client.send(method) do |request|
            configure_request(request, params, headers, body)
          end
        rescue => e
          rescue_error(e)
        end
        parse(response.body)
      end

      def configure_request(request, params = nil, headers = nil, body = nil)
        request.params.merge!(params) if params
        request.headers['Content-Type'] = 'application/json'
        request.headers.merge!(headers) if headers
        request.body = body if body
        request.options.timeout = timeout
      end

      def parse(response)
        return nil if response.nil?

        begin
          MultiJson.load(response).to_h
        rescue MultiJson::ParseError
          exception_message = "Couldn't parse response body: #{response}"
          exception = ParsingError.new(exception_message)
          build_error(exception,
                      'Error parsing the response as body.',
                      'The response given by the server is not in JSON format.',
                      response,
                      response)
          exception.status_code = -1
          raise exception
        end
      end

      def url
        "#{configuration.base_url}#{version_path}#{path}"
      end

      def version_path
        "v#{version}/"
      end

      def path
        @path_steps.join('/')
      end

      def rescue_error(exception)
        cartodb_exception = Error.new(exception.message)

        is_faraday_exception = exception.is_a?(Faraday::Error::ClientError)
        if is_faraday_exception && exception.response
          cartodb_exception = build_error_from_faraday(cartodb_exception, exception)
        end

        raise cartodb_exception
      end

      def build_error_from_faraday(cartodb_exception, exception)
        cartodb_exception.status_code = exception.response[:status]
        begin
          response = MultiJson.load(exception.response[:body])
          build_error(cartodb_exception,
                      response['title'],
                      response['detail'],
                      response,
                      exception.response[:body]) if response
        rescue MultiJson::ParseError => _
        end
        cartodb_exception
      end

      def build_error(exception, title, details, body, raw_body = nil)
        exception.title = title if title
        exception.details = details if details
        exception.body = body
        exception.raw_body = raw_body if raw_body
      end
    end
  end
end
