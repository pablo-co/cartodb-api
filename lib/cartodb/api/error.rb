module CartoDB
  module Api
    class CartoDBError < StandardError
      attr_accessor :title, :details, :body, :raw_body, :status_code
    end

    class ConnectionFailed < CartoDBError
    end

    class InvalidConfiguration < CartoDBError
    end

    class ApiError < CartoDBError
      def to_s
        whole_message = "the server responded with status #{status_code}"
        whole_message = append_to_message(whole_message, title)
        whole_message = append_to_message(whole_message, details)
        append_to_message(whole_message, body)
      end

      private

      def append_to_message(message, text)
        if text && !text.empty?
          "#{message}\n#{text}"
        else
          message
        end
      end
    end

    class ParsingError < ApiError
    end
  end
end
