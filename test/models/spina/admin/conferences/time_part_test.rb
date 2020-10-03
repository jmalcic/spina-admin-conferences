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

        test 'returns date' do
          assert_equal @time_part.content.to_date, @time_part.date
          assert_nil @new_time_part.date
        end

        test 'setting date updates content' do
          assert_changes '@time_part.content.inspect', to: @time_part.content.+(1.day).inspect do
            @time_part.date = @time_part.date + 1.day
          end
          assert_changes '@time_part.content' do
            @time_part.date = nil
          end
          assert_nil @time_part.content
          assert_changes '@new_time_part.content' do
            @new_time_part.date = Date.today.iso8601 # rubocop:disable Rails/Date
          end
          assert_changes '@new_time_part.content' do
            @new_time_part.date = nil
          end
          assert_nil @new_time_part.content
        end

        test 'returns start time' do
          assert_equal @time_part.content, @time_part.time
          assert_nil @new_time_part.time
        end

        test 'setting start time updates start datetime' do
          assert_changes '@time_part.content.inspect', to: @time_part.content.+(2.hours).beginning_of_minute.inspect do
            @time_part.time = @time_part.time.+(2.hours).to_formatted_s(:time)
          end
          assert_changes '@time_part.content' do
            @time_part.time = nil
          end
          assert_nil @time_part.content
          assert_changes '@new_time_part.content' do
            @new_time_part.time = DateTime.current.to_formatted_s(:time)
          end
          assert_changes '@new_time_part.content' do
            @new_time_part.time = nil
          end
          assert_nil @new_time_part.content
        end
      end
    end
  end
end
