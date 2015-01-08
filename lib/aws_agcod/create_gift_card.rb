require "aws_agcod/request"

module AwsAgcod
  class CreateGiftCard
    delegate :success?, :error_message, to: :@response

    def initialize(request_id, amount)
      @response = Request.new("CreateGiftCard", request_id,
        "value" => {
          "currencyCode" => "USD",
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
