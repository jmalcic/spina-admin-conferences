# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class DatePartTest < ActiveSupport::TestCase
        setup do
          @date_part = spina_admin_conferences_date_parts :valid_date
          @new_date_part = DatePart.new
        end

        test 'date part has associated page parts' do
          assert_not_empty @date_part.page_parts
          assert_empty @new_date_part.page_parts
        end

        test 'date part has associated parts' do
          assert_not_empty @date_part.parts
          assert_empty @new_date_part.parts
        end

        test 'date part has associated layout parts' do
          assert_not_empty @date_part.layout_parts
          assert_empty @new_date_part.layout_parts
        end

        test 'date part has associated structure parts' do
          assert_not_empty @date_part.structure_parts
          assert_empty @new_date_part.structure_parts
        end
      end
    end
  end
end
