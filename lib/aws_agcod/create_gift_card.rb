require "aws_agcod/request"

module AwsAgcod
  class CreateGiftCardError < StandardError; end

  class CreateGiftCard
    extend Forwardable

    CURRENCIES = %w(USD EUR JPY CNY CAD)

    def_delegators :@response, :success?, :error_message

    def initialize(request_id, amount, currency = "USD")
      if CURRENCIES.include?(currency.to_s)
        raise CreateGiftCardError, "Currency #{currency} not supported, support types are #{CURRENCIES.join(", ")}"
      end

      @response = Request.new("CreateGiftCard",
        "creationRequestId" => "#{AwsAgcod.config.partner_id}#{request_id}",
        "value" => {
          "currencyCode" => currency,
          "amount" => amount
        }
      ).response
    end

    def claim_code
      @response.payload["gcClaimCode"]
    end

    def gc_id
      @response.payload["gcId"]
    end

    def request_id
      @response.payload["creationRequestId"]
    end
  end
end
