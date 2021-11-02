require "aws_agcod/request"

module AGCOD
  class GetAvailableFunds
    extend Forwardable

    def_delegators :@response, :status, :success?, :error_message

    def initialize
      @response = Request.new("GetAvailableFunds").response
    end

    def amount
      @response.payload["availableFunds"]["amount"]
    end

    def currency_code
      @response.payload["availableFunds"]["currencyCode"]
    end

    def timestamp
      @timestamp ||= Time.parse @response.payload["timestamp"]
    end
  end
end
