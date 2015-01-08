require "json"

module AwsAgcod
  class Response
    attr_reader :status, :payload

    def initialize(raw_json)
      @payload = JSON.parse(raw_json)

      # All status:
      # SUCCESS -- Operation succeeded
      # FAILURE -- Operation failed
      # RESEND -- A temporary/recoverable system failure that can be resolved by the partner retrying the request
      @status = if payload["status"]
        payload["status"]
      elsif payload["agcodResponse"]
        payload["agcodResponse"]["status"]
      else
        "FAILURE"
      end
    end

    def success?
      status == "SUCCESS"
    end

    def error_message
      "#{payload["errorCode"]} #{payload["errorType"]} - #{payload["message"]}"
    end
  end
end
