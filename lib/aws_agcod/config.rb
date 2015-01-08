module AwsAgcod
  class Config
    attr_accessor :access_key, :secret_key, :uri, :partner_id, :region

    def initialize
      # API defaults
      @uri = "https://agcod-v2-gamma.amazon.com"
      @region = "us-east-1"
    end
  end
end
