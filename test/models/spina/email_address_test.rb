require "test_helper"

describe Spina::EmailAddress do
  let(:email_address) { Spina::EmailAddress.new }

  it "must be valid" do
    value(email_address).must_be :valid?
  end
end
