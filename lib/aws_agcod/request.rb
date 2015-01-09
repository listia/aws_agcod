require "aws_agcod/signature"
require "aws_agcod/response"
require "httparty"
require "yaml"

module AGCOD
  class Request
    TIME_FORMAT = "%Y%m%dT%H%M%SZ"

    attr_reader :response

    def initialize(action, params)
      @action = action
      @params = params

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
        "partnerId" => AGCOD.config.partner_id
      ).to_json
    end
  end
end
