require "spec_helper"
require "aws_agcod/get_available_funds"

describe AGCOD::GetAvailableFunds do
  let(:partner_id) { "Testa" }
  let(:response) { spy }

  before do
    AGCOD.configure do |config|
      config.partner_id = partner_id
    end
  end

  context ".new" do
    it "makes get available funds request" do
      expect(AGCOD::Request).to receive(:new) do |action|
        expect(action).to eq("GetAvailableFunds")
      end.and_return(response)

      AGCOD::GetAvailableFunds.new
    end
  end

  shared_context "request with response" do
    let(:amount) { 10 }
    let(:currency) { AGCOD::CreateGiftCard::CURRENCIES.first }
    let(:timestamp) { "20211102T054653Z" }
    let(:status) { "SUCCESS" }
    let(:payload) { { "availableFunds" => { "amount" => amount, "currencyCode" => currency }, "timestamp" => timestamp } }
    let(:request) { AGCOD::GetAvailableFunds.new }

    before do
      allow(AGCOD::Request).to receive(:new) { double(response: response) }
      allow(response).to receive(:payload) { payload }
      allow(response).to receive(:status) { status }
    end
  end

  context "#amount" do
    include_context "request with response"

    it "returns amount" do
      expect(request.amount).to eq(amount)
    end
  end

  context "#currency_code" do
    include_context "request with response"

    it "returns currency_code" do
      expect(request.currency_code).to eq(currency)
    end
  end

  context "#timestamp" do
    include_context "request with response"

    it "returns expiration_date" do
      expect(request.timestamp).to eq(Time.parse timestamp)
    end
  end

  context "#status" do
    include_context "request with response"

    it "returns the response status" do
      expect(request.status).to eq(status)
    end
  end
end
