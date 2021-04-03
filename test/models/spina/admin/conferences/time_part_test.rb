# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class TimePartTest < ActiveSupport::TestCase
        setup do
          @time_part = spina_admin_conferences_time_parts :valid_time
          @new_time_part = TimePart.new
        end

        test 'time part has associated page parts' do
          assert_not_empty @time_part.page_parts
          assert_empty @new_time_part.page_parts
        end

        test 'time part has associated parts' do
          assert_not_empty @time_part.parts
          assert_empty @new_time_part.parts
        end

        test 'time part has associated layout parts' do
          assert_not_empty @time_part.layout_parts
          assert_empty @new_time_part.layout_parts
        end

        test 'time part has associated structure parts' do
          assert_not_empty @time_part.structure_parts
          assert_empty @new_time_part.structure_parts
        end
      end
    end
  end
end
