require "test_helper"

describe Spina::Delegate do
  let(:delegate) { Spina::Delegate.new }

  it "must be valid" do
    value(delegate).must_be :valid?
  end
end
