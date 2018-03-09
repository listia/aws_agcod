require "aws_agcod/request"

module AGCOD
  class GiftCardActivityListError < StandardError; end

  class GiftCardActivity
    attr_reader :status, :created_at, :type, :card_number, :amount, :error_code,
                :gc_id, :partner_id, :request_id

    def initialize(payload)
      @payload = payload
      @status = payload["activityStatus"]
      @created_at = payload["activityTime"]
      @type = payload["activityType"]
      @card_number = payload["cardNumber"]
      @amount = payload["cardValue"]["amount"] if payload["cardValue"]
      @error_code = payload["failureCode"]
      @gc_id = payload["gcId"]
      @partner_id = payload["partnerId"]
      @request_id = payload["requestId"]
    end

    def is_real?
      @payload["isRealOp"] == "true"
    end
  end

  class GiftCardActivityList
    extend Forwardable

    LIMIT = 1000 # limit per request
    TIME_FORMAT = "%Y-%m-%dT%H:%M:%SZ"

    def_delegators :@response, :success?, :error_message

    def initialize(httpable, request_id, start_time, end_time, page = 1, per_page = 100, show_no_ops = false)
      raise GiftCardActivityListError, "Only #{LIMIT} records allowed per request." if per_page > LIMIT

      @response = Request.new(httpable,"GetGiftCardActivityPage",
        "requestId" => request_id,
        "utcStartDate" => start_time.strftime(TIME_FORMAT),
        "utcEndDate" => end_time.strftime(TIME_FORMAT),
        "pageIndex" => (page - 1) * per_page,
        "pageSize" => per_page,
        "showNoOps" => show_no_ops
      ).response
    end

    def results
      @response.payload["cardActivityList"].map { |payload| GiftCardActivity.new(payload) }
    end
  end
end

