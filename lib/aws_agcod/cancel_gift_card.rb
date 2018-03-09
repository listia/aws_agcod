require "aws_agcod/request"

module AGCOD
  class CancelGiftCard
    extend Forwardable

    def_delegators :@response, :status, :success?, :error_message

    def initialize(httpable, request_id, gc_id)
      @response = Request.new(httpable,"CancelGiftCard",
        "creationRequestId" => request_id,
        "gcId" => gc_id
      ).response
    end
  end
end
