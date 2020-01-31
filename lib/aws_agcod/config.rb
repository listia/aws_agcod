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
      # US/CA（NA）
      'us-east-1' => {
        sandbox: "https://agcod-v2-gamma.amazon.com",
        production: "https://agcod-v2.amazon.com"
      },
      # IT/ES/DE/FR/UK（EU）
      'eu-west-1' => {
        sandbox: "https://agcod-v2-eu-gamma.amazon.com/",
        production: "https://agcod-v2-eu.amazon.com"
      },
      # JP（FE）
      'us-west-2' => {
        sandbox: "https://agcod-v2-fe-gamma.amazon.com",
        production: "https://agcod-v2-fe.amazon.com"
      },
    }

    def initialize
      # API defaults
      @production = false
      @region = "us-east-1"
      @timeout = 30
    end

    def uri
      return @uri if @uri

      production ? URI[@region][:production] : URI[@region][:sandbox]
    end
  end
end
