# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationsControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
        include ::Spina::Engine.routes.url_helpers

        setup do
          @presentation = spina_admin_conferences_presentations :asymmetry_and_antisymmetry
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_presentations_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_presentation_url
          assert_response :success
          assert_select '#presenters tbody > tr' do
            assert_select 'td', 'There are no delegates'
          end
        end

        test 'should get edit' do
          get edit_admin_conferences_presentation_url(@presentation)
          assert_response :success
          assert_select('#presenters tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should get edit in locale' do
          get edit_admin_conferences_presentation_url(@presentation, locale: :en)
          assert_response :success
          assert_select('#presenters tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create presentation' do
          assert_difference 'Presentation.count' do
            post admin_conferences_presentations_url,
                 params: { presentation: { presenter_ids: [ActiveRecord::FixtureSet.identify(:brandon_krapp)],
                                           start_datetime: DateTime.parse('2017-04-08 10:00'),
                                           session_id: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                           title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                  'theoretical inadequacy',
                                           abstract: 'Dolor sit amen' } }
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
          assert_not_nil Presentation.i18n
                                     .joins(:presenters)
                                     .find_by(presenters: { id: ActiveRecord::FixtureSet.identify(:brandon_krapp) },
                                              start_datetime: DateTime.parse('2017-04-08 10:00'),
                                              session: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                              title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                     'theoretical inadequacy',
                                              abstract: 'Dolor sit amen')
        end

        test 'should create presentation with remote form' do
          assert_difference 'Presentation.count' do
            post admin_conferences_presentations_url,
                 params: { presentation: { presenter_ids: [ActiveRecord::FixtureSet.identify(:brandon_krapp)],
                                           start_datetime: DateTime.parse('2017-04-08 10:00'),
                                           session_id: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                           title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                  'theoretical inadequacy',
                                           abstract: 'Dolor sit amen' } },
                 as: :turbo_stream
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
          assert_not_nil Presentation.i18n
                                     .joins(:presenters)
                                     .find_by(presenters: { id: ActiveRecord::FixtureSet.identify(:brandon_krapp) },
                                              start_datetime: DateTime.parse('2017-04-08 10:00'),
                                              session: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                              title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                     'theoretical inadequacy',
                                              abstract: 'Dolor sit amen')
        end

        test 'should fail to create invalid presentation' do
          assert_no_difference 'Presentation.count' do
            post admin_conferences_presentations_url,
                 params: { presentation: { presenter_ids: [], start_datetime: nil, session_id: nil, title: nil, abstract: nil } }
          end
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to create invalid presentation with remote form' do
          assert_no_difference 'Presentation.count' do
            post admin_conferences_presentations_url,
                 params: { presentation: { presenter_ids: [], start_datetime: nil, session_id: nil, title: nil, abstract: nil } },
                 as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should update presentation' do
          patch admin_conferences_presentation_url(@presentation),
                params: { presentation: { presenter_ids: [ActiveRecord::FixtureSet.identify(:brandon_krapp)],
                                          start_datetime: DateTime.parse('2017-04-08 10:00'),
                                          session_id: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                          title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                 'theoretical inadequacy',
                                          abstract: 'Dolor sit amen' } }
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
          assert_not_nil Presentation.i18n
                                     .joins(:presenters)
                                     .find_by(id: @presentation.id,
                                              presenters: { id: ActiveRecord::FixtureSet.identify(:brandon_krapp) },
                                              start_datetime: DateTime.parse('2017-04-08 10:00'),
                                              session: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                              title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                     'theoretical inadequacy',
                                              abstract: 'Dolor sit amen')
        end

        test 'should update presentation with remote form' do
          patch admin_conferences_presentation_url(@presentation),
                params: { presentation: { presenter_ids: [ActiveRecord::FixtureSet.identify(:brandon_krapp)],
                                          start_datetime: DateTime.parse('2017-04-08 10:00'),
                                          session_id: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                          title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                 'theoretical inadequacy',
                                          abstract: 'Dolor sit amen' } },
                as: :turbo_stream
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation saved', flash[:success]
          assert_not_nil Presentation.i18n
                                     .joins(:presenters)
                                     .find_by(id: @presentation.id,
                                              presenters: { id: ActiveRecord::FixtureSet.identify(:brandon_krapp) },
                                              start_datetime: DateTime.parse('2017-04-08 10:00'),
                                              session: ActiveRecord::FixtureSet.identify(:oral_1_lecture_block_3_uoa_2017),
                                              title: 'The entire discussion of phonology in this book suffers from a fundamental ' \
                                                     'theoretical inadequacy',
                                              abstract: 'Dolor sit amen')
        end

        test 'should fail to update invalid presentation' do
          patch admin_conferences_presentation_url(@presentation),
                params: { presentation: { presenter_ids: [], start_datetime: nil, session_id: nil, title: nil, abstract: nil } }
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should fail to update invalid presentation with remote form' do
          patch admin_conferences_presentation_url(@presentation),
                params: { presentation: { presenter_ids: [], start_datetime: nil, session_id: nil, title: nil, abstract: nil } },
                as: :turbo_stream
          assert_response :success
          assert_not_equal 'Presentation saved', flash[:success]
        end

        test 'should update presentation in locale' do
          assert_changes -> { @presentation.reload.title(locale: :en) }, to: 'Antisymmetry and asymmetry' do
            patch admin_conferences_presentation_url(@presentation),
                  params: { presentation: { title: 'Antisymmetry and asymmetry' }, locale: :en }
            assert_redirected_to admin_conferences_presentations_url
            assert_equal 'Presentation saved', flash[:success]
          end
          assert_changes -> { @presentation.reload.abstract(locale: :en).try(:to_plain_text) }, to: 'Dolor sit amen.' do
            patch admin_conferences_presentation_url(@presentation),
                  params: { presentation: { abstract: 'Dolor sit amen.' }, locale: :en }
            assert_redirected_to admin_conferences_presentations_url
            assert_equal 'Presentation saved', flash[:success]
          end
          assert_not_equal 'Antisymmetry and asymmetry', @presentation.reload.title
          assert_not_equal 'Dolor sit amen.', @presentation.reload.abstract.to_plain_text
        end

        test 'should update presentation in locale with remote form' do
          assert_changes -> { @presentation.reload.title(locale: :en) }, to: 'Antisymmetry and asymmetry' do
            patch admin_conferences_presentation_url(@presentation),
                  params: { presentation: { title: 'Antisymmetry and asymmetry' }, locale: :en }, as: :turbo_stream
            assert_redirected_to admin_conferences_presentations_url
            assert_equal 'Presentation saved', flash[:success]
          end
          assert_changes -> { @presentation.reload.abstract(locale: :en).try(:to_plain_text) }, to: 'Dolor sit amen.' do
            patch admin_conferences_presentation_url(@presentation),
                  params: { presentation: { abstract: 'Dolor sit amen.' }, locale: :en }, as: :turbo_stream
            assert_redirected_to admin_conferences_presentations_url
            assert_equal 'Presentation saved', flash[:success]
          end
          assert_not_equal 'Antisymmetry and asymmetry', @presentation.reload.title
          assert_not_equal 'Dolor sit amen.', @presentation.reload.abstract.to_plain_text
        end

        test 'should destroy presentation' do
          assert_difference 'Presentation.count', -1 do
            delete admin_conferences_presentation_url(@presentation)
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation deleted', flash[:success]
        end

        test 'should destroy presentation with remote form' do
          assert_difference 'Presentation.count', -1 do
            delete admin_conferences_presentation_url(@presentation), as: :turbo_stream
          end
          assert_redirected_to admin_conferences_presentations_url
          assert_equal 'Presentation deleted', flash[:success]
        end

        test 'should fail to destroy presentation if impossible' do
          callbacks = Presentation._destroy_callbacks
          Presentation.before_destroy { throw :abort }
          assert_no_difference 'Presentation.count' do
            delete admin_conferences_presentation_url(@presentation)
          end
          assert_response :success
          assert_not_equal 'Presentation deleted', flash[:success]
          Presentation._destroy_callbacks = callbacks
        end

        test 'should fail to destroy presentation if impossible with remote form' do
          callbacks = Presentation._destroy_callbacks
          Presentation.before_destroy { throw :abort }
          assert_no_difference 'Presentation.count' do
            delete admin_conferences_presentation_url(@presentation), as: :turbo_stream
          end
          assert_response :success
          assert_not_equal 'Presentation deleted', flash[:success]
          Presentation._destroy_callbacks = callbacks
        end

        test 'should enqueue presentation import' do
          file_fixture('presentations.csv.erb').read
            .then { |file| ERB.new(file).result(binding) }
            .then { |result| Pathname.new(File.join(file_fixture_path, 'presentations.csv')).write(result) }
          assert_enqueued_with job: PresentationImportJob do
            post import_admin_conferences_presentations_url,
                 params: { file: fixture_file_upload(file_fixture('presentations.csv')) }
          end
        end
      end
    end
  end
end
