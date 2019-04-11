# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class RoomImportJobTest < ActiveJob::TestCase
      include ::Spina::Conferences

      test 'that number of rooms changes' do
        assert_difference 'Room.count', 6 do
          RoomImportJob.perform_now File.open(file_fixture('rooms.csv'))
        end
      end

      test 'room import scheduling' do
        assert_enqueued_with job: RoomImportJob do
          Room.import File.open(file_fixture('rooms.csv'))
        end
      end

      test 'room import performing' do
        assert_performed_with job: RoomImportJob do
          Room.import File.open(file_fixture('rooms.csv'))
        end
      end
    end
  end
end
