require "spec_helper"
require "aws_agcod/config"

describe AGCOD::Config do
  context ".new" do
    let!(:config) { AGCOD::Config.new }

    it "sets default uri and region" do
      expect(config.uri).not_to be_nil
      expect(config.region).not_to be_nil
      expect(config.timeout).not_to be_nil
    end
  end
end
