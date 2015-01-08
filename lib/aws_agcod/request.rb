require "aws_agcod/signature"
require "aws_agcod/response"
require "httparty"
require "yaml"

module AwsAgcod
  class Request
    TIME_FORMAT = "%Y%m%dT%H%M%SZ"

    attr_reader :response

    def initialize(action, request_id, params)
      @action = action
      @request_id = request_id
      @params = params

      @response = Response.new(HTTParty.post(uri, body: body, headers: signed_headers, timeout: 30).body)
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

      Signature.new(AwsAgcod.config).sign(uri, headers, body)
    end

    def uri
      @uri ||= URI("#{AwsAgcod.config.uri}/#{@action}")
    end

    def body
      @body ||= @params.merge(
        "partnerId" => AwsAgcod.config.partner_id,
        "creationRequestId" => "#{AwsAgcod.config.partner_id}#{@request_id}"
      ).to_json
    end
  end
end
