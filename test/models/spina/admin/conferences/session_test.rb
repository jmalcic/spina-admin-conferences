# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class SessionTest < ActiveSupport::TestCase
        setup do
          @session = spina_admin_conferences_sessions :oral_1_lecture_block_2_uoa_2017
          @new_session = Session.new
        end

        test 'translates name' do
          @session.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @session.name
          @session.name = 'bar'
          assert_equal 'bar', @session.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @session.name
        end

        test 'session has associated room' do
          assert_not_nil @session.room
          assert_nil @new_session.room
        end

        test 'session has associated presentation type' do
          assert_not_nil @session.presentation_type
          assert_nil @new_session.presentation_type
        end

        test 'session has associated conference' do
          assert_not_nil @session.conference
          assert_nil @new_session.conference
        end

        test 'session has associated institution' do
          assert_not_nil @session.institution
          assert_nil @new_session.institution
        end

        test 'session has associated presentations' do
          assert_not_empty @session.presentations
          assert_empty @new_session.presentations
        end

        test 'room must not be empty' do
          assert @session.valid?
          assert_empty @session.errors[:room]
          @session.room = nil
          assert @session.invalid?
          assert_not_empty @session.errors[:room]
        end

        test 'presentation type must not be empty' do
          assert @session.valid?
          assert_empty @session.errors[:presentation_type]
          @session.presentation_type = nil
          assert @session.invalid?
          assert_not_empty @session.errors[:presentation_type]
        end

        test 'name must not be empty' do
          assert @session.valid?
          assert_empty @session.errors[:name]
          @session.name = nil
          assert @session.invalid?
          assert_not_empty @session.errors[:name]
        end

        test 'returns a room name' do
          assert_not_empty @session.room_name
          assert_nil @new_session.room_name
        end

        test 'returns a presentation type name' do
          assert_not_empty @session.presentation_type_name
          assert_nil @new_session.presentation_type_name
        end
      end
    end
  end
end
