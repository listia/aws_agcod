require "aws_agcod/signature"
require "aws_agcod/response"
require "faraday"

module AGCOD
  class Request
    AMAZON_TIME_FORMAT = "%Y%m%dT%H%M%SZ"
    DATE_TIME_FORMAT   = "%Y-%m-%d %H:%M:%S %Z" # Ruby 1.8 has a different default time format

    attr_reader :response

    def initialize(action, params)
      @action = action
      @params = params

      @response = Response.new(raw_response.body)
    end

    private

    def connection
      @connection ||= Faraday.new(AGCOD.config.uri, :request => { :timeout => AGCOD.config.timeout })
    end

    def raw_response
      connection.post uri.path, body, signed_headers
    end

    def signed_headers
      time = Time.now.utc

      headers = {
        "content-type" => "application/json",
        "x-amz-date" => time.strftime(AMAZON_TIME_FORMAT),
        "accept" => "application/json",
        "host" => uri.host,
        "x-amz-target" => "com.amazonaws.agcod.AGCODService.#{@action}",
        "date" => time.strftime(DATE_TIME_FORMAT)
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
