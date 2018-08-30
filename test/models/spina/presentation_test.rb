require "test_helper"

describe Spina::Presentation do
  let(:presentation) { Spina::Presentation.new }

  it "must be valid" do
    value(presentation).must_be :valid?
  end
end
