require "spec_helper"
require "aws_agcod/cancel_gift_card"

describe AGCOD::CancelGiftCard do
  let(:partner_id) { "Testa" }

  before do
    AGCOD.configure do |config|
      config.partner_id = partner_id
    end
  end

  context ".new" do
    let(:request_id) { "test1" }
    let(:gc_id) { "FOO" }

    it "makes cancel request" do
      expect(AGCOD::Request).to receive(:new) do |action, params|
        expect(action).to eq("CancelGiftCard")
        expect(params["creationRequestId"]).to eq("#{partner_id}#{request_id}")
        expect(params["gcId"]).to eq(gc_id)
      end.and_return(spy)

      AGCOD::CancelGiftCard.new(request_id, gc_id)
    end
  end
end
