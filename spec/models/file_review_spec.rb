require "rails_helper"

describe FileReview do
  describe "associations" do
    it { should belong_to :build }
  end

  describe "validations" do
    it { should validate_presence_of :build }
  end

  describe "#completed?" do
    it "returns true where completed_at is set" do
      file_review = FileReview.new(completed_at: Time.now)

      expect(file_review.completed?).to eq true
    end

    it "returns false where completed_at is nil" do
      file_review = FileReview.new

      expect(file_review.completed?).to eq false
    end
  end

  describe "#running?" do
    it "returns true where complete_at is nil" do
      file_review = FileReview.new(completed_at: Time.now)

      expect(file_review.running?).to eq false
    end

    it "returns false where completed_at is set" do
      file_review = FileReview.new(completed_at: nil)

      expect(file_review.running?).to eq true
    end
  end
end
