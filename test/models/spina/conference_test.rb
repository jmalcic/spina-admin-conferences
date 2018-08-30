require "test_helper"

describe Spina::Conference do
  let(:conference) { Spina::Conference.new }

  it "must be valid" do
    value(conference).must_be :valid?
  end
end
