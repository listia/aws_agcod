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
      sandbox: "https://agcod-v2-gamma.amazon.com",
      production: "https://agcod-v2.amazon.com"
    }

    def initialize
      # API defaults
      @production = false
      @region = "us-east-1"
      @timeout = 30
    end

    def uri
      return @uri if @uri

      production ? URI[:production] : URI[:sandbox]
    end
  end
end
