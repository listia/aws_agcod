require "spec_helper"
require "aws_agcod"

describe AGCOD do
  context ".configure" do
    it "yields config" do
      AGCOD.configure do |config|
        expect(config).to be_an_instance_of(AGCOD::Config)
      end
    end
  end
end
