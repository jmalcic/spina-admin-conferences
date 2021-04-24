# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class ConferencesControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
        include ::Spina::Engine.routes.url_helpers

        setup do
          @conference = spina_admin_conferences_conferences :university_of_atlantis_2017
          @invalid_conference = Conference.new
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
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          assert_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { conference: attributes }
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should create conference with remote form' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          assert_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { conference: attributes }, as: :turbo_stream
          end
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should fail to create invalid conference' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          assert_no_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { conference: attributes }
          end
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should fail to create invalid conference with remote form' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          assert_no_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { conference: attributes }, as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should update conference' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          patch admin_conferences_conference_url(@conference), params: { conference: attributes }
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should update conference with remote form' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          patch admin_conferences_conference_url(@conference), params: { conference: attributes }, as: :turbo_stream
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          patch admin_conferences_conference_url(@conference), params: { conference: attributes }
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference with remote form' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          patch admin_conferences_conference_url(@conference), params: { conference: attributes }, as: :turbo_stream
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should update conference in locale' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          patch admin_conferences_conference_url(@conference), params: { conference: attributes, locale: :en }
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
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
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          attributes[:'en-GB_content_attributes'] = [
            { title: 'Submission text', name: 'submission_text', content: 'Dolor sit amen', type: 'Spina::Parts::Line' }
          ]
          assert_changes -> { @conference.reload.content(:submission_text) }, from: 'Lorem ipsum', to: 'Dolor sit amen' do
            patch admin_conferences_conference_url(@conference), params: { conference: attributes }
          end
        end

        test 'should save generic structure part' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          attributes[:'en-GB_content_attributes'] = [
            { title: 'Sponsors', name: 'sponsors', type: 'Spina::Parts::Repeater', content_attributes: [
              { title: 'Sponsors', name: 'sponsors', parts_attributes: [
                { title: 'Name', name: 'name', content: 'Another sponsor', type: 'Spina::Parts::Line' }
              ] }
            ] }
          ]
          assert_changes -> { @conference.reload.content(:sponsors).first.content('name') }, from: 'Some sponsor', to: 'Another sponsor' do
            patch admin_conferences_conference_url(@conference), params: { conference: attributes }, as: :turbo_stream
          end
        end

        test 'should save structure part image' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          attributes[:'en-GB_content_attributes'] = [
            { title: 'Sponsors', name: 'sponsors', type: 'Spina::Parts::Repeater', content_attributes: [
              { title: 'Sponsors', name: 'sponsors', parts_attributes: [
                { title: 'Logo', name: 'logo', type: 'Spina::Parts::Image', image_id: @rovinj_image.id, filename: 'logo.jpeg',
                  signed_blob_id: '', alt: 'Logo' }
              ] }
            ] }
          ]
          assert_changes -> { @conference.reload.content(:sponsors).first.content(:logo).spina_image },
                         from: @logo, to: @rovinj_image do
            patch admin_conferences_conference_url(@conference), params: { conference: attributes }, as: :turbo_stream
          end
        end

        test 'should render form when partable missing' do
          get edit_admin_conferences_conference_url(@empty_conference)
        end
      end
    end
  end
end
