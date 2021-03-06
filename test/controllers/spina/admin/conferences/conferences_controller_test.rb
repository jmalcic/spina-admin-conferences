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
          @dubrovnik_image = spina_images(:dubrovnik)
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
            assert_select 'td', I18n.t('spina.admin.conferences.delegates.index.no_delegates')
          end
          assert_select '#presentation_types tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.presentation_types.index.no_presentation_types')
          end
          assert_select '#presentations tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.presentations.index.no_presentations')
          end
          assert_select '#rooms tbody > tr' do
            assert_select 'td', I18n.t('spina.admin.conferences.rooms.index.no_rooms')
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

        test 'should create conference' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          assert_difference 'Conference.count' do
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes }
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
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes }, as: :turbo_stream
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
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes }
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
            post admin_conferences_conferences_url, params: { admin_conferences_conference: attributes }, as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should update conference' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should update conference with remote form' do
          attributes = @conference.attributes
          attributes[:start_date] = @conference.start_date
          attributes[:finish_date] = @conference.finish_date
          attributes[:name] = @conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }, as: :turbo_stream
          assert_redirected_to admin_conferences_conferences_url
          assert_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
        end

        test 'should fail to update invalid conference with remote form' do
          attributes = @invalid_conference.attributes
          attributes[:start_date] = @invalid_conference.start_date
          attributes[:finish_date] = @invalid_conference.finish_date
          attributes[:name] = @invalid_conference.name
          patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }, as: :turbo_stream
          assert_response :success
          assert_not_equal 'Conference saved', flash[:success]
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
          attributes = @conference.attributes.merge(start_date: @conference.start_date, finish_date: @conference.finish_date,
                                                    name: @conference.name, parts_attributes:
                                                      @conference.parts.collect do |part|
                                                        part.attributes.merge({ 'partable_attributes' => part.partable.attributes })
                                                      end)
          attributes[:parts_attributes].find { |part| part['name'] == 'submission_text' }
                                       .then { |part| part['partable_attributes']['content'] = 'Dolor sit amen' }
          assert_changes -> { @conference.content('submission_text') }, from: 'Lorem ipsum dolor sit amet', to: 'Dolor sit amen' do
            patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }, as: :turbo_stream
          end
        end

        test 'should save generic structure part' do
          attributes = @conference.attributes.merge(start_date: @conference.start_date, finish_date: @conference.finish_date,
                                                    name: @conference.name, parts_attributes:
                                                      @conference.parts.collect do |part|
                                                        part.attributes.merge({ 'partable_attributes' => part.partable.attributes })
                                                      end)
          sponsors = @conference.parts.find_by(name: 'sponsors')
          attributes[:parts_attributes].find { |part| part['name'] == 'sponsors' }.then do |part|
            part['partable_attributes']['structure_items_attributes'] = sponsors.partable.structure_items.collect do |structure_item|
              structure_item.attributes.merge({ 'structure_parts_attributes' => structure_item.structure_parts.collect do |structure_part|
                structure_part.attributes.merge({ 'partable_attributes' => structure_part.partable.attributes })
              end })
            end
          end
          attributes[:parts_attributes].find { |part| part['name'] == sponsors.name }.then do |part|
            part['partable_attributes']['structure_items_attributes']
              .first['structure_parts_attributes']
              .find { |structure_part| structure_part['name'] == 'name' }
              .then { |structure_part| structure_part['partable_attributes']['content'] = 'Test' }
          end
          assert_changes -> { @conference.content('sponsors').structure_items.first.content('name') },
                         from: 'Lorem ipsum dolor sit amet', to: 'Test' do
            patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }, as: :turbo_stream
          end
        end

        test 'should save structure part image' do
          attributes = @conference.attributes.merge(start_date: @conference.start_date, finish_date: @conference.finish_date,
                                                    name: @conference.name, parts_attributes:
                                                      @conference.parts.collect do |part|
                                                        part.attributes.merge({ 'partable_attributes' => part.partable.attributes })
                                                      end)
          sponsors = @conference.parts.find_by(name: 'sponsors')
          attributes[:parts_attributes].find { |part| part['name'] == 'sponsors' }.then do |part|
            part['partable_attributes']['structure_items_attributes'] = sponsors.partable.structure_items.collect do |structure_item|
              structure_item.attributes.merge({ 'structure_parts_attributes' => structure_item.structure_parts.collect do |structure_part|
                structure_part.attributes.merge({ 'partable_attributes' => structure_part.partable.attributes })
              end })
            end
          end
          attributes[:parts_attributes].find { |part| part['name'] == sponsors.name }.then do |part|
            part['partable_attributes']['structure_items_attributes']
              .first['structure_parts_attributes']
              .find { |structure_part| structure_part['name'] == 'logo' }
              .tap { |structure_part| structure_part.delete('partable_attributes') }
              .then { |structure_part| structure_part['partable_id'] = @rovinj_image.id }
          end
          assert_changes -> { @conference.content('sponsors').structure_items.first.content('logo') },
                         from: @dubrovnik_image, to: @rovinj_image do
            patch admin_conferences_conference_url(@conference), params: { admin_conferences_conference: attributes }, as: :turbo_stream
          end
        end

        test 'should render form when partable missing' do
          get edit_admin_conferences_conference_url(@empty_conference)
        end
      end
    end
  end
end
