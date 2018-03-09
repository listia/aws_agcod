require "spec_helper"
require "aws_agcod/gift_card_activity_list"

describe AGCOD::GiftCardActivityList do
  let(:partner_id) { "Testa" }
  let(:request_id) { "test1" }
  let(:start_time) { double("start_time") }
  let(:end_time) { double("end_time") }
  let(:page) { 1 }
  let(:per_page) { AGCOD::GiftCardActivityList::LIMIT }
  let(:show_no_ops) { true }
  let(:response) { spy }
  let(:httpable) { HTTP }

  before do
    AGCOD.configure do |config|
      config.partner_id = partner_id
    end
  end

  context ".new" do
    it "makes request" do
      expect(start_time).to receive(:strftime).with(
        AGCOD::GiftCardActivityList::TIME_FORMAT
      ).and_return(start_time)

      expect(end_time).to receive(:strftime).with(
        AGCOD::GiftCardActivityList::TIME_FORMAT
      ).and_return(end_time)

      expect(AGCOD::Request).to receive(:new) do |_, action, params|
        expect(action).to eq("GetGiftCardActivityPage")
        expect(params["requestId"]).to eq(request_id)
        expect(params["utcStartDate"]).to eq(start_time)
        expect(params["utcEndDate"]).to eq(end_time)
        expect(params["pageIndex"]).to eq((page - 1) * per_page)
        expect(params["pageSize"]).to eq(per_page)
        expect(params["showNoOps"]).to eq(show_no_ops)
      end.and_return(response)

      AGCOD::GiftCardActivityList.new(httpable, request_id, start_time, end_time, page, per_page, show_no_ops)
    end

    context "when request per_page reaches limit" do
      let(:per_page) { AGCOD::GiftCardActivityList::LIMIT + 1 }

      it "raises error" do
        expect {
          AGCOD::GiftCardActivityList.new(httpable, request_id, start_time, end_time, page, per_page, show_no_ops)
        }.to raise_error(
          AGCOD::GiftCardActivityListError,
          "Only #{AGCOD::GiftCardActivityList::LIMIT} records allowed per request."
        )
      end
    end
  end

  context "#results" do
    let(:payload) { { "cardActivityList" => [spy] } }
    let(:request) { AGCOD::GiftCardActivityList.new(httpable, request_id, start_time, end_time, page, per_page, show_no_ops) }

    before do
      allow(start_time).to receive(:strftime)
      allow(end_time).to receive(:strftime)
      allow(AGCOD::Request).to receive(:new) { double(response: response) }
      allow(response).to receive(:payload) { payload }
    end

    it "returns GiftCardActivity instances" do
      request.results.each do |item|
        expect(item).to be_a(AGCOD::GiftCardActivity)
      end
    end
  end
end
