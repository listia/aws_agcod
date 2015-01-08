require "aws_agcod/request"

module AwsAgcod
  class CancelGiftCard
    delegate :success?, :error_message, to: :@response

    def initialize(request_id, gc_id)
      @response = Request.new("CancelGiftCard", request_id, "gcId" => gc_id).response
    end
  end
end
