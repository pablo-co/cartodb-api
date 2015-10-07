require 'faraday'
require 'multi_json'

require 'cartodb/api/version'
require 'cartodb/api/request'
require 'cartodb/api/configuration'
require 'cartodb/api/error'

module CartoDB
  module Api
    class << self
      # Public: Initializes a new CartoDB::Api::Request.
      #
      # configuration - The optional CartoDB::Api::Configuration used to configure
      #                 this CartoDB::Api::Request.
      #
      # Examples
      #
      #   CartoDB::Api.new 'http://faraday.com'
      #
      #
      # Returns a CartoDB::Api::Request.
      def new(configuration)
        build_request(configuration)
      end

      def method_missing(sym, *args, &block)
        build_request.send(sym, *args, &block)
      end

      def default_configuration=(configuration)
        @@default_configuration = configuration
      end

      protected

      def build_request(configuration = nil)
        configuration = configuration ? default_configuration.merge(configuration) : default_configuration.dup
        CartoDB::Api::Request.new(configuration)
      end

      private

      def default_configuration
        @@default_configuration ||= CartoDB::Api::Configuration.new
      end

    end
  end
end