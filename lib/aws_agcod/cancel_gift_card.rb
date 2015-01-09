require "aws_agcod/request"

module AGCOD
  class CancelGiftCard
    extend Forwardable

    def_delegators :@response, :success?, :error_message

    def initialize(request_id, gc_id)
      @response = Request.new("CancelGiftCard",
        "creationRequestId" => "#{AGCOD.config.partner_id}#{request_id}",
        "gcId" => gc_id
      ).response
    end
  end
end
