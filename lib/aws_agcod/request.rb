require "aws_agcod/signature"
require "aws_agcod/response"
require "http"
require "yaml"

module AGCOD
  class Request
    TIME_FORMAT = "%Y%m%dT%H%M%SZ"

    attr_reader :response

    def initialize(httpable, action, params) # httpable is anything that can have post called upon it; this allows passing in a proxy
      @action = action
      @params = sanitized_params(params)

      @response = Response.new(httpable.post(uri, body: body, headers: signed_headers, timeout: AGCOD.config.timeout).body)
    end

    private

    def signed_headers
      time = Time.now.utc

      headers = {
        "content-type" => "application/json",
        "x-amz-date" => time.strftime(TIME_FORMAT),
        "accept" => "application/json",
        "host" => uri.host,
        "x-amz-target" => "com.amazonaws.agcod.AGCODService.#{@action}",
        "date" => time.to_s
      }

      Signature.new(AGCOD.config).sign(uri, headers, body)
    end

    def uri
      @uri ||= URI("#{AGCOD.config.uri}/#{@action}")
    end

    def body
      @body ||= @params.merge(
        "partnerId" => AGCOD.config.partner_id
      ).to_json
    end

    def sanitized_params(params)
      # Prefix partner_id when it's not given as part of request_id for creationRequestId
      if params["creationRequestId"] && !(params["creationRequestId"] =~ /#{AGCOD.config.partner_id}/)
        params["creationRequestId"] = "#{AGCOD.config.partner_id}#{params["creationRequestId"]}"
      end

      # Remove partner_id when it's prefixed in requestId
      if params["requestId"] && !!(params["requestId"] =~ /^#{AGCOD.config.partner_id}/)
        params["requestId"].sub!(/^#{AGCOD.config.partner_id}/, "")
      end

      params
    end
  end
end
