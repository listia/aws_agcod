module AGCOD
  class Config
    attr_accessor :access_key, :secret_key, :uri, :partner_id, :region, :timeout

    def initialize
      # API defaults
      @uri = "https://agcod-v2-gamma.amazon.com"
      @region = "us-east-1"
      @timeout = 30
    end
  end
end
