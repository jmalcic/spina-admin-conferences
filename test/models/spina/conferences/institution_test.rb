# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class InstitutionTest < ActiveSupport::TestCase
      setup do
        @institution = spina_conferences_institutions(:university_of_atlantis)
      end

      test 'institution attributes must not be empty' do
        institution = Institution.new
        assert institution.invalid?
        assert institution.errors[:name].any?
        assert institution.errors[:city].any?
      end
    end
  end
end
