module AwsAgcod
  class Config
    attr_accessor :access_key, :secret_key, :uri, :partner_id, :region

    def initialize
      # Default to test endpoint
      @uri = "https://agcod-v2-gamma.amazon.com"
    end
  end
end
