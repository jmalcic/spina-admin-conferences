require "test_helper"

describe Spina::Date do
  let(:date) { Spina::Date.new }

  it "must be valid" do
    value(date).must_be :valid?
  end
end
