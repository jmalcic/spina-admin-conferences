require "test_helper"

describe Spina::Url do
  let(:url) { Spina::Url.new }

  it "must be valid" do
    value(url).must_be :valid?
  end
end
