# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class SessionsControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
        include ::Spina::Engine.routes.url_helpers

        setup do
          @session = spina_admin_conferences_sessions :oral_1_lecture_block_2_uoa_2017
          @empty_session = spina_admin_conferences_sessions :empty_session
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_sessions_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_session_url
          assert_response :success
          assert_select '#presentations tbody > tr' do
            assert_select 'td', 'There are no presentations'
          end
        end

        test 'should get edit' do
          get edit_admin_conferences_session_url(@session)
          assert_response :success
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should get edit in locale' do
          get edit_admin_conferences_session_url(@session, locale: :en)
          assert_response :success
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create session' do
          assert_difference 'Session.count' do
            post admin_conferences_sessions_url, params: { session: { presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                                                      room_id: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                                                      name: 'Orals in Lecture Block 3' } }
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
          assert_not_nil Session.i18n.find_by(presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                              room: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                              name: 'Orals in Lecture Block 3')
        end

        test 'should create session with remote form' do
          assert_difference 'Session.count' do
            post admin_conferences_sessions_url,
                 params: { session: { presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                      room_id: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                      name: 'Orals in Lecture Block 3' } },
                 as: :turbo_stream
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
          assert_not_nil Session.i18n.find_by(presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                              room: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                              name: 'Orals in Lecture Block 3')
        end

        test 'should fail to create invalid session' do
          assert_no_difference 'Session.count' do
            post admin_conferences_sessions_url, params: { session: { presentation_type_id: nil, room_id: nil, name: nil } }
          end
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should fail to create invalid session with remote form' do
          assert_no_difference 'Session.count' do
            post admin_conferences_sessions_url,
                 params: { session: { presentation_type_id: nil, room_id: nil, name: nil } }, as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should update session' do
          patch admin_conferences_session_url(@session),
                params: { session: { presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                     room_id: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                     name: 'Orals in Lecture Block 3' } }
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
          assert_not_nil Session.i18n.find_by(id: @session.id,
                                              presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                              room: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                              name: 'Orals in Lecture Block 3')
        end

        test 'should update session with remote form' do
          patch admin_conferences_session_url(@session),
                params: { session: { presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                     room_id: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                     name: 'Orals in Lecture Block 3' } },
                as: :turbo_stream
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session saved', flash[:success]
          assert_not_nil Session.i18n.find_by(id: @session.id,
                                              presentation_type_id: ActiveRecord::FixtureSet.identify(:oral_2),
                                              room: ActiveRecord::FixtureSet.identify(:lecture_block_3),
                                              name: 'Orals in Lecture Block 3')
        end

        test 'should fail to update invalid session' do
          patch admin_conferences_session_url(@session), params: { session: { presentation_type_id: nil, room_id: nil, name: nil } }
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should fail to update invalid session with remote form' do
          patch admin_conferences_session_url(@session),
                params: { session: { presentation_type_id: nil, room_id: nil, name: nil } }, as: :turbo_stream
          assert_response :success
          assert_not_equal 'Session saved', flash[:success]
        end

        test 'should update session in locale' do
          assert_changes -> { @session.reload.name(locale: :en) }, to: 'Talks in Lecture Block Two' do
            patch admin_conferences_session_url(@session),
                  params: { session: { name: 'Talks in Lecture Block Two' }, locale: :en }
            assert_redirected_to admin_conferences_sessions_url
            assert_equal 'Session saved', flash[:success]
          end
          assert_not_equal 'Talks in Lecture Block Two', @session.reload.name
        end

        test 'should update session in locale with remote form' do
          assert_changes -> { @session.reload.name(locale: :en) }, to: 'Talks in Lecture Block Two' do
            patch admin_conferences_session_url(@session),
                  params: { session: { name: 'Talks in Lecture Block Two' }, locale: :en }, as: :turbo_stream
            assert_redirected_to admin_conferences_sessions_url
            assert_equal 'Session saved', flash[:success]
          end
          assert_not_equal 'Talks in Lecture Block Two', @session.reload.name
        end

        test 'should destroy session' do
          assert_difference 'Session.count', -1 do
            delete admin_conferences_session_url(@empty_session)
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session deleted', flash[:success]
        end

        test 'should destroy session with remote form' do
          assert_difference 'Session.count', -1 do
            delete admin_conferences_session_url(@empty_session), as: :turbo_stream
          end
          assert_redirected_to admin_conferences_sessions_url
          assert_equal 'Session deleted', flash[:success]
        end

        test 'should fail to destroy session with dependent records' do
          assert_no_difference 'Session.count' do
            delete admin_conferences_session_url(@session)
          end
          assert_response :success
          assert_not_equal 'Session deleted', flash[:success]
        end

        test 'should fail to destroy session with dependent records with remote form' do
          assert_no_difference 'Session.count' do
            delete admin_conferences_session_url(@session), as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Session deleted', flash[:success]
        end
      end
    end
  end
end
