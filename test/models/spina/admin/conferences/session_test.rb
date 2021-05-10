# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class SessionTest < ActiveSupport::TestCase
        setup do
          @session_without_dependencies = spina_admin_conferences_sessions :session_without_dependencies
          @session_with_presentations = spina_admin_conferences_sessions :session_with_presentations
          @new_session = Session.new
        end

        test 'translates name' do
          @session_without_dependencies.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @session_without_dependencies.name
          @session_without_dependencies.name = 'bar'
          assert_equal 'bar', @session_without_dependencies.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @session_without_dependencies.name
        end

        test 'session has associated room' do
          assert_not_nil @session_without_dependencies.room
          assert_nil @new_session.room
        end

        test 'session has associated presentation type' do
          assert_not_nil @session_without_dependencies.presentation_type
          assert_nil @new_session.presentation_type
        end

        test 'session has associated conference' do
          assert_not_nil @session_without_dependencies.conference
          assert_nil @new_session.conference
        end

        test 'session has associated institution' do
          assert_not_nil @session_without_dependencies.institution
          assert_nil @new_session.institution
        end

        test 'session has associated presentations' do
          assert_not_empty @session_with_presentations.presentations
          assert_empty @new_session.presentations
        end

        test 'does not destroy associated presentations' do
          assert_no_difference 'Presentation.count' do
            @session_with_presentations.destroy
          end
          assert_not_empty @session_with_presentations.errors[:base]
        end

        test 'room must not be empty' do
          assert @session_without_dependencies.valid?
          assert_empty @session_without_dependencies.errors[:room]
          @session_without_dependencies.room = nil
          assert @session_without_dependencies.invalid?
          assert_not_empty @session_without_dependencies.errors[:room]
        end

        test 'presentation type must not be empty' do
          assert @session_without_dependencies.valid?
          assert_empty @session_without_dependencies.errors[:presentation_type]
          @session_without_dependencies.presentation_type = nil
          assert @session_without_dependencies.invalid?
          assert_not_empty @session_without_dependencies.errors[:presentation_type]
        end

        test 'name must not be empty' do
          assert @session_without_dependencies.valid?
          assert_empty @session_without_dependencies.errors[:name]
          @session_without_dependencies.name = nil
          assert @session_without_dependencies.invalid?
          assert_not_empty @session_without_dependencies.errors[:name]
        end

        test 'returns a room name' do
          assert_not_empty @session_without_dependencies.room_name
          assert_nil @new_session.room_name
        end

        test 'returns a presentation type name' do
          assert_not_empty @session_without_dependencies.presentation_type_name
          assert_nil @new_session.presentation_type_name
        end
      end
    end
  end
end
