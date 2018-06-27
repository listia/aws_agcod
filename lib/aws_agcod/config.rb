module AGCOD
  class Config
    attr_writer :uri
    attr_accessor :access_key,
                  :secret_key,
                  :partner_id,
                  :region,
                  :timeout,
                  :production

    URI = {
      sandbox: {
        "us-east-1" => "https://agcod-v2-gamma.amazon.com",
        "eu-west-1" => "https://agcod-v2-eu-gamma.amazon.com",
        "us-west-2" => "https://agcod-v2-fe-gamma.amazon.com"
      },
      production: {
        "us-east-1" => "https://agcod-v2.amazon.com",
        "eu-west-1" => "https://agcod-v2-eu.amazon.com",
        "us-west-2" => "https://agcod-v2-fe.amazon.com"
      }
    }

    def initialize
      # API defaults
      @production = false
      @region = "us-east-1"
      @timeout = 30
    end

    def uri
      return @uri if @uri
      production ? URI[:production][@region] : URI[:sandbox][@region]
    end
  end
end
