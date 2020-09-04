# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PartTest < ActiveSupport::TestCase
        setup do
          @part = spina_admin_conferences_parts :text
          @empty_part = spina_admin_conferences_parts :empty_text
          @new_part = Part.new
        end

        test 'part has associated pageable' do
          assert_not_nil @part.pageable
          assert_nil @new_part.pageable
        end

        test 'part has associated partable' do
          assert_not_nil @part.partable
          assert_nil @new_part.partable
        end

        test 'pageable must not be empty' do
          assert @part.valid?
          assert_empty @part.errors[:pageable]
          @part.pageable = nil
          assert @part.invalid?
          assert_not_empty @part.errors[:pageable]
        end

        test 'partable must not be empty' do
          assert @part.valid?
          assert_empty @part.errors[:partable]
          @part.partable = nil
          assert @part.invalid?
          assert_not_empty @part.errors[:partable_type]
        end

        test 'name must be unique for pageable' do
          assert @empty_part.valid?
          assert_empty @empty_part.errors[:name]
          @empty_part.pageable = @part.pageable
          @empty_part.name = @part.name
          assert @empty_part.invalid?
          assert_not_empty @empty_part.errors[:name]
          @empty_part.name = 'Lorem ipsum'
          assert @empty_part.valid?
          assert_empty @empty_part.errors[:name]
          @empty_part.name = @part.name
          @empty_part.pageable = spina_admin_conferences_conferences(:university_of_shangri_la_2018)
          assert @empty_part.valid?
          assert_empty @empty_part.errors[:name]
        end

        test 'accepts nested attributes for partable' do
          assert_changes '@part.partable.content' do
            @part.partable_attributes = { content: 'Dolor sit amen' }
          end
        end
      end
    end
  end
end
