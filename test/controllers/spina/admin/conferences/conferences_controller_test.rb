# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferencesControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
        include ::Spina::Engine.routes.url_helpers

        setup do
          @conference = spina_admin_conferences_conferences :university_of_atlantis_2017
          @empty_conference = spina_admin_conferences_conferences :empty_conference
          @user = spina_users :joe
          @rovinj_image = spina_images(:rovinj)
          @logo = spina_images(:logo)
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_conferences_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_conference_url
          assert_response :success
          assert_select '#delegates tbody > tr' do
            assert_select 'td', 'There are no delegates'
          end
          assert_select '#presentation_types tbody > tr' do
            assert_select 'td', 'There are no presentation types'
          end
          assert_select '#presentations tbody > tr' do
            assert_select 'td', 'There are no presentations'
          end
          assert_select '#rooms tbody > tr' do
            assert_select 'td', 'There are no rooms'
          end
        end

        test 'should get edit' do
          get edit_admin_conferences_conference_url(@conference)
          assert_response :success
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select '#presentation_types tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select('#rooms tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should get edit in locale' do
          get edit_admin_conferences_conference_url(@conference, locale: :en)
          assert_response :success
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select '#presentation_types tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select '#presentations tbody > tr' do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select('#rooms tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create conference' do
          assert_difference 'Conference.count' do
            post admin_conferences_conferences_url,
                 params: { conference: { start_date: Date.parse('2017-04-07'),
                                         finish_date: Date.parse('2017-04-09'),
                                         name: 'University of Atlantis 2017' } }
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should create conference with remote form' do
          assert_difference 'Conference.count' do
            post admin_conferences_conferences_url,
                 params: { conference: { start_date: Date.parse('2017-04-07'),
                                         finish_date: Date.parse('2017-04-09'),
                                         name: 'University of Atlantis 2017' } },
                 as: :turbo_stream
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should fail to create invalid conference' do
          assert_no_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { conference: { start_date: nil, finish_date: nil, name: nil } }
          end
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should fail to create invalid conference with remote form' do
          assert_no_difference 'Conference.count' do
            post admin_conferences_conferences_url,
                 params: { conference: { start_date: nil, finish_date: nil, name: nil } },
                 as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should update conference' do
          patch admin_conferences_conference_url(@conference),
                params: { conference: { start_date: Date.parse('2017-04-07'),
                                        finish_date: Date.parse('2017-04-09'),
                                        name: 'University of Atlantis 2017' } }
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should update conference with remote form' do
          patch admin_conferences_conference_url(@conference),
                params: { conference: { start_date: Date.parse('2017-04-07'),
                                        finish_date: Date.parse('2017-04-09'),
                                        name: 'University of Atlantis 2017' } },
                as: :turbo_stream
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference' do
          patch admin_conferences_conference_url(@conference), params: { conference: { start_date: nil, finish_date: nil, name: nil } }
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference with remote form' do
          patch admin_conferences_conference_url(@conference),
                params: { conference: { start_date: nil, finish_date: nil, name: nil } },
                as: :turbo_stream
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should update conference in locale' do
          assert_changes -> { @conference.reload.name(locale: :en) }, to: 'MALT' do
            patch admin_conferences_conference_url(@conference), params: { conference: { name: 'MALT' }, locale: :en }
            assert_redirected_to admin_conferences_conferences_url
            assert_equal 'Conference saved', flash[:success]
          end
          assert_not_equal 'MALT', @conference.reload.name
        end

        test 'should update conference in locale with remote form' do
          assert_changes -> { @conference.reload.name(locale: :en) }, to: 'MALT' do
            patch admin_conferences_conference_url(@conference), params: { conference: { name: 'MALT' }, locale: :en }, as: :turbo_stream
            assert_redirected_to admin_conferences_conferences_url
            assert_equal 'Conference saved', flash[:success]
          end
          assert_not_equal 'MALT', @conference.reload.name
        end

        test 'should destroy conference' do
          assert_difference 'Conference.count', -1 do
            delete admin_conferences_conference_url(@empty_conference)
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference deleted', flash[:success]
        end

        test 'should destroy conference with remote form' do
          assert_difference 'Conference.count', -1 do
            delete admin_conferences_conference_url(@empty_conference), as: :turbo_stream
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference deleted', flash[:success]
        end

        test 'should fail to destroy conference with dependent records' do
          assert_no_difference 'Conference.count' do
            delete admin_conferences_conference_url(@conference)
          end
          assert_response :success
          assert_not_equal 'Conference deleted', flash[:success]
        end

        test 'should fail to destroy conference with dependent records with remote form' do
          assert_no_difference 'Conference.count' do
            delete admin_conferences_conference_url(@conference), as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Conference deleted', flash[:success]
        end

        test 'should save generic part' do
          assert_changes -> { @conference.reload.content(:submission_text) }, to: 'Dolor sit amen' do
            patch admin_conferences_conference_url(@conference),
                  params: { conference: {
                    'en-GB_content_attributes': [
                      { title: 'Submission text', name: 'submission_text', content: 'Dolor sit amen', type: 'Spina::Parts::Line' }
                    ]
                  } }
          end
        end

        test 'should save generic part with remote form' do
          assert_changes -> { @conference.reload.content(:submission_text) }, to: 'Dolor sit amen' do
            patch admin_conferences_conference_url(@conference),
                  as: :turbo_stream,
                  params: { conference: {
                    'en-GB_content_attributes': [
                      { title: 'Submission text', name: 'submission_text', content: 'Dolor sit amen', type: 'Spina::Parts::Line' }
                    ]
                  } }
          end
        end

        test 'should save generic structure part' do
          assert_changes -> { @conference.reload.content(:sponsors).first.content('name') }, to: 'Another sponsor' do
            patch admin_conferences_conference_url(@conference),
                  params: { conference: {
                    'en-GB_content_attributes': [
                      { title: 'Sponsors', name: 'sponsors', type: 'Spina::Parts::Repeater', content_attributes: [
                        { title: 'Sponsors', name: 'sponsors', parts_attributes: [
                          { title: 'Name', name: 'name', content: 'Another sponsor', type: 'Spina::Parts::Line' }
                        ] }
                      ] }
                    ]
                  } }
          end
        end

        test 'should save generic structure part with remote form' do
          assert_changes -> { @conference.reload.content(:sponsors).first.content('name') }, to: 'Another sponsor' do
            patch admin_conferences_conference_url(@conference),
                  as: :turbo_stream,
                  params: { conference: {
                    'en-GB_content_attributes': [
                      { title: 'Sponsors', name: 'sponsors', type: 'Spina::Parts::Repeater', content_attributes: [
                        { title: 'Sponsors', name: 'sponsors', parts_attributes: [
                          { title: 'Name', name: 'name', content: 'Another sponsor', type: 'Spina::Parts::Line' }
                        ] }
                      ] }
                    ]
                  } }
          end
        end

        test 'should save structure part image' do
          assert_changes -> { @conference.reload.content(:sponsors).first.content(:logo).spina_image }, to: @rovinj_image do
            patch admin_conferences_conference_url(@conference),
                  params: { conference: {
                    'en-GB_content_attributes': [
                      { title: 'Sponsors', name: 'sponsors', type: 'Spina::Parts::Repeater', content_attributes: [
                        { title: 'Sponsors', name: 'sponsors', parts_attributes: [
                          { title: 'Logo', name: 'logo', type: 'Spina::Parts::Image', image_id: @rovinj_image.id, filename: 'logo.jpeg',
                            signed_blob_id: '', alt: 'Logo' }
                        ] }
                      ] }
                    ]
                  } }
          end
        end

        test 'should save structure part image with remote form' do
          assert_changes -> { @conference.reload.content(:sponsors).first.content(:logo).spina_image }, to: @rovinj_image do
            patch admin_conferences_conference_url(@conference),
                  as: :turbo_stream,
                  params: { conference: {
                    'en-GB_content_attributes': [
                      { title: 'Sponsors', name: 'sponsors', type: 'Spina::Parts::Repeater', content_attributes: [
                        { title: 'Sponsors', name: 'sponsors', parts_attributes: [
                          { title: 'Logo', name: 'logo', type: 'Spina::Parts::Image', image_id: @rovinj_image.id, filename: 'logo.jpeg',
                            signed_blob_id: '', alt: 'Logo' }
                        ] }
                      ] }
                    ]
                  } }
          end
        end

        test 'should render form when partable missing' do
          get edit_admin_conferences_conference_url(@empty_conference)
        end
      end
    end
  end
end
