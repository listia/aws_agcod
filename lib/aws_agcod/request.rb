require "aws_agcod/signature"
require "aws_agcod/response"
require "httparty"
require "yaml"

module AGCOD
  class Request
    TIME_FORMAT = "%Y%m%dT%H%M%SZ".freeze
    MOCK_REQUEST_IDS = %w(F0000 F2005).freeze

    attr_reader :response

    def initialize(action, params = {})
      @action = action
      @params = sanitized_params(params)

      @response = Response.new(HTTParty.post(uri, body: body, headers: signed_headers, timeout: AGCOD.config.timeout).body)
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
        "partnerId" => partner_id
      ).to_json
    end

    def sanitized_params(params)
      # Prefix partner_id in creationRequestId when it's not given as part of request_id, and it's not a mocked request_id.
      if params["creationRequestId"] &&
        !(params["creationRequestId"] =~ /#{partner_id}/) &&
        !(MOCK_REQUEST_IDS.member?(params["creationRequestId"]))

        params["creationRequestId"] = "#{partner_id}#{params["creationRequestId"]}"
      end

      # Remove partner_id when it's prefixed in requestId
      if params["requestId"] && !!(params["requestId"] =~ /^#{partner_id}/)
        params["requestId"].sub!(/^#{partner_id}/, "")
      end

      params
    end

    def partner_id
      @partner_id ||= AGCOD.config.partner_id
    end
  end
end
