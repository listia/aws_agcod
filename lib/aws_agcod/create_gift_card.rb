require "aws_agcod/request"

module AGCOD
  class CreateGiftCardError < StandardError; end

  class CreateGiftCard
    extend Forwardable

    CURRENCIES = %w(USD EUR JPY CNY CAD)

    def_delegators :@response, :status, :success?, :error_message

    def initialize(httpable, request_id, amount, currency = "USD")
      unless CURRENCIES.include?(currency.to_s)
        raise CreateGiftCardError, "Currency #{currency} not supported, available types are #{CURRENCIES.join(", ")}"
      end

      @response = Request.new(httpable, "CreateGiftCard",
        "creationRequestId" => request_id,
        "value" => {
          "currencyCode" => currency,
          "amount" => amount
        }
      ).response
    end

    def claim_code
      @response.payload["gcClaimCode"]
    end

    def expiration_date
      @expiration_date ||= Time.parse @response.payload["gcExpirationDate"]
    end

    def gc_id
      @response.payload["gcId"]
    end

    def request_id
      @response.payload["creationRequestId"]
    end
  end
end
