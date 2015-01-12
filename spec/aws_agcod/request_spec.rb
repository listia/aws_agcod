require "spec_helper"
require "aws_agcod/request"

describe AGCOD::Request do
  let(:action) { "Foo" }
  let(:params) { {} }
  let(:signature) { double("Signature") }
  let(:signed_headers) { double("signed_headers") }
  let(:base_uri) { "https://example.com" }
  let(:partner_id) { "BAR" }
  let(:timeout) { 10 }
  let(:config) { double(:uri => base_uri, :partner_id => partner_id, :timeout => timeout) }
  let(:connection) { double("Connection") }
  let(:request_options) { { :request => { :timeout => config.timeout } } }

  context "#new" do
    before do
      allow(AGCOD).to receive(:config) { config }
      allow(AGCOD::Signature).to receive(:new).with(config) { signature }
    end

    it "sends post request to endpoint uri" do
      expect(signature).to receive(:sign) do |uri, headers, body|
        expect(uri).to eq(URI("#{base_uri}/#{action}"))
        expect(headers.keys).to match_array(%w(content-type x-amz-date accept host x-amz-target date))
        expect(headers["content-type"]).to eq("application/json")
        expect(headers["x-amz-target"]).to eq("com.amazonaws.agcod.AGCODService.#{action}")
        expect(JSON.parse(body)["partnerId"]).to eq(partner_id)
      end.and_return(signed_headers)

      expect(Faraday).to receive(:new).with(base_uri, request_options) { connection }

      expect(connection).to receive(:post) do |path, body, headers|
        expect(path).to eq(URI("#{base_uri}/#{action}").path)
        expect(JSON.parse(body)["partnerId"]).to eq(partner_id)
        expect(headers).to eq(signed_headers)
      end.and_return(double(:body => params.to_json))

      AGCOD::Request.new(action, params)
    end

    it "sets response" do
      expect(signature).to receive(:sign) { signed_headers }
      expect(connection).to receive(:post) { (double(:body => params.to_json)) }
      expect(Faraday).to receive(:new).with(base_uri, request_options) { connection }

      response = AGCOD::Request.new(action, params).response

      expect(response).to be_a(AGCOD::Response)
    end
  end
end
