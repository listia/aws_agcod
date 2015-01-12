require "spec_helper"
require "aws_agcod/response"

describe AGCOD::Response do
  let(:payload) { { :foo => "bar" }.to_json }

  context "#new" do
    it "sets payload and status" do
      response = AGCOD::Response.new(payload)

      expect(response.payload).not_to be_nil
      expect(response.status).not_to be_nil
    end

    context "when no status in payload" do
      it "sets status to failure" do
        expect(AGCOD::Response.new(payload).status).to eq("FAILURE")
      end
    end

    context "when has status in payload" do
      let(:status) { "foo" }
      let(:payload) { { :status => status }.to_json }

      it "sets status as payload's status" do
        expect(AGCOD::Response.new(payload).status).to eq(status)
      end
    end

    context "when has agcodResponse in payload" do
      let(:status) { "foo" }
      let(:payload) { { :agcodResponse => { :status => status } }.to_json }

      it "sets status as agcodResponse's status" do
        expect(AGCOD::Response.new(payload).status).to eq(status)
      end
    end
  end

  context "success?" do
    context "when status is SUCCESS" do
      let(:payload) { { :status => "SUCCESS" }.to_json }

      it "returns true" do
        expect(AGCOD::Response.new(payload).success?).to be_truthy
      end
    end

    context "when status is not SUCCESS" do
      it "returns false" do
        expect(AGCOD::Response.new(payload).success?).to be_falsey
      end
    end
  end

  context "error_message" do
    let(:error_code) { "foo" }
    let(:error_type) { "bar" }
    let(:error_message) { "baz" }
    let(:payload) { { :errorCode => error_code, :errorType => error_type, :message => error_message }.to_json }

    it "composes error message by error code, type, and message from payload" do
      expect(AGCOD::Response.new(payload).error_message).to eq("#{error_code} #{error_type} - #{error_message}")
    end
  end
end
