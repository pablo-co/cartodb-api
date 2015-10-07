module CartoDB
  module Api
    class ConnectionFailed < StandardError
    end

    class InvalidConfiguration < StandardError
    end

    class Error < StandardError
      attr_accessor :title, :details, :body, :raw_body, :status_code
    end

    class ParsingError < Error
    end
  end
end
