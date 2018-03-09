require "spec_helper"
require "aws_agcod/cancel_gift_card"

describe AGCOD::CancelGiftCard do
  let(:partner_id) { "Testa" }
  let(:response) { spy }
  let(:httpable) { HTTP }

  before do
    AGCOD.configure do |config|
      config.partner_id = partner_id
    end
  end

  context ".new" do
    let(:request_id) { "test1" }
    let(:gc_id) { "FOO" }

    it "makes cancel request" do
      expect(AGCOD::Request).to receive(:new) do |_, action, params|
        expect(action).to eq("CancelGiftCard")
        expect(params["creationRequestId"]).to eq(request_id)
        expect(params["gcId"]).to eq(gc_id)
      end.and_return(response)

      AGCOD::CancelGiftCard.new(httpable, request_id, gc_id)
    end
  end

  shared_context "request with response" do
    let(:gc_id) { "BAR" }
    let(:creation_request_id) { "BAZ" }
    let(:status) { "SUCCESS" }
    let(:request) { AGCOD::CancelGiftCard.new(httpable, creation_request_id, gc_id) }

    before do
      allow(AGCOD::Request).to receive(:new) { double(response: response) }
      allow(response).to receive(:status) { status }
    end
  end

  context "#status" do
    include_context "request with response"

    it "returns the response status" do
      expect(request.status).to eq(status)
    end
  end
end
