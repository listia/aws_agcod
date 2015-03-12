require "spec_helper"
require "aws_agcod/create_gift_card"

describe AGCOD::CreateGiftCard do
  let(:partner_id) { "Testa" }
  let(:request_id) { "test1" }
  let(:amount) { 10 }
  let(:currency) { AGCOD::CreateGiftCard::CURRENCIES.first }
  let(:response) { spy }

  before do
    AGCOD.configure do |config|
      config.partner_id = partner_id
    end
  end

  context ".new" do
    context "when currency available" do
      it "makes create request" do
        expect(AGCOD::Request).to receive(:new) do |action, params|
          expect(action).to eq("CreateGiftCard")
          expect(params["creationRequestId"]).to eq(request_id)
          expect(params["value"]).to eq(
            "currencyCode" => currency,
            "amount" => amount
          )
        end.and_return(response)

        AGCOD::CreateGiftCard.new(request_id, amount, currency)
      end
    end

    context "when currency not available" do
      let(:currency) { "NOTEXIST" }

      it "raises error" do
        expect {
          AGCOD::CreateGiftCard.new(request_id, amount, currency)
        }.to raise_error(
          AGCOD::CreateGiftCardError,
          "Currency #{currency} not supported, available types are #{AGCOD::CreateGiftCard::CURRENCIES.join(", ")}"
        )
      end
    end
  end

  shared_context "request with response" do
    let(:claim_code) { "FOO" }
    let(:expiration_date) { "Wed Mar 12 22:59:59 UTC 2025" }
    let(:gc_id) { "BAR" }
    let(:creation_request_id) { "BAZ" }
    let(:payload) { {"gcClaimCode" => claim_code, "gcId" => gc_id, "creationRequestId" => creation_request_id, "gcExpirationDate" => expiration_date} }
    let(:request) { AGCOD::CreateGiftCard.new(request_id, amount, currency) }

    before do
      allow(AGCOD::Request).to receive(:new) { double(response: response) }
      allow(response).to receive(:payload) { payload }
    end
  end

  context "#claim_code" do
    include_context "request with response"

    it "returns claim_code" do
      expect(request.claim_code).to eq(claim_code)
    end
  end

  context "#expiration_date" do
    include_context "request with response"

    it "returns expiration_date" do
      expect(request.expiration_date).to eq(Time.parse expiration_date)
    end
  end

  context "#gc_id" do
    include_context "request with response"

    it "returns gc_id" do
      expect(request.gc_id).to eq(gc_id)
    end
  end

  context "#request_id" do
    include_context "request with response"

    it "returns creation request_id" do
      expect(request.request_id).to eq(creation_request_id)
    end
  end
end
