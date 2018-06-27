require "spec_helper"
require "aws_agcod/config"

describe AGCOD::Config do
  let(:config) { AGCOD::Config.new }

  context ".new" do
    it "sets default uri and region" do
      expect(config.uri).not_to be_nil
      expect(config.region).not_to be_nil
      expect(config.timeout).not_to be_nil
      expect(config.production).to eq(false)
    end
  end

  context "#uri" do
    context "when uri is set" do
      before do
        config.uri = "https://custom-uri.example.com"
      end

      it "returns the custom uri" do
        expect(config.uri).to eq("https://custom-uri.example.com")
      end
    end

    context "when uri is not set" do
      context "with default region" do
        context "when production is enabled" do
          before do
            config.production = true
          end

          it "returns the us-east-1 production uri" do
            expect(config.uri).to eq(AGCOD::Config::URI[:production]["us-east-1"])
          end
        end

        context "when production is disabled" do
          it "returns the us-east-1 sandbox uri" do
            expect(config.uri).to eq(AGCOD::Config::URI[:sandbox]["us-east-1"])
          end
        end
      end

      context "with specified region" do
        before do
          config.region = "eu-west-1"
        end

        context "when production is enabled" do
          before do
            config.production = true
          end

          it "returns the specified production uri" do
            expect(config.uri).to eq(AGCOD::Config::URI[:production]["eu-west-1"])
          end
        end

        context "when production is disabled" do
          it "returns the us-east-1 sandbox uri" do
            expect(config.uri).to eq(AGCOD::Config::URI[:sandbox]["eu-west-1"])
          end
        end
      end
    end
  end
end
