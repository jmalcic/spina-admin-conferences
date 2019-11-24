# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PagesFlowTest < ActionDispatch::IntegrationTest
      include ::Spina::Engine.routes.url_helpers

      test 'visit homepage' do
        spina_images(:dubrovnik).file.attach(io: fixture_file_upload(file_fixture('dubrovnik.jpeg')),
                                             filename: 'dubrovnik.jpeg',
                                             content_type: 'image/jpeg')
        spina_images(:rovinj).file.attach(io: fixture_file_upload(file_fixture('rovinj.jpeg')),
                                          filename: 'rovinj.jpeg',
                                          content_type: 'image/jpeg')
        in_locales :en do
          get spina_pages(:homepage).materialized_path
          assert_response :success
          assert_select '[data-controller="slideshow"]' do
            assert_select 'img[data-target="slideshow.slide"]', 2, html: %r{/rails/active_storage/representations/}
          end
        end
      end

      test 'visit empty homepage' do
        spina_images(:dubrovnik).file.attach(io: fixture_file_upload(file_fixture('dubrovnik.jpeg')),
                                             filename: 'dubrovnik.jpeg',
                                             content_type: 'image/jpeg')
        spina_images(:rovinj).file.attach(io: fixture_file_upload(file_fixture('rovinj.jpeg')),
                                          filename: 'rovinj.jpeg',
                                          content_type: 'image/jpeg')
        in_locales :en do
          get spina_pages(:empty_homepage).materialized_path
          assert_response :success
          assert_select '[data-controller="slideshow"]', false
        end
      end

      test 'visit information page' do
        in_locales :en do
          get spina_pages(:information).materialized_path
          assert_response :success
          assert_select 'div.markdown-body', spina_page_parts(:information_page_text).partable.content
        end
      end

      test 'visit empty information page' do
        in_locales :en do
          get spina_pages(:empty_information).materialized_path
          assert_response :success
          assert_select 'div.markdown-body', text: spina_page_parts(:information_page_text).partable.content, count: 0
        end
      end

      test 'visit about page' do
        spina_images(:dubrovnik).file.attach(io: fixture_file_upload(file_fixture('dubrovnik.jpeg')),
                                             filename: 'dubrovnik.jpeg',
                                             content_type: 'image/jpeg')
        %i[constitution agm_2019_minutes].each do |fixture|
          spina_attachments(fixture).file.attach(io: fixture_file_upload(file_fixture('blank.pdf')),
                                                 filename: 'blank.pdf',
                                                 content_type: 'application/pdf')
        end
        in_locales :en do
          get spina_pages(:about).materialized_path
          assert_response :success
          assert_select 'div.markdown-body', spina_page_parts(:about_page_text).partable.content
          assert_select 'a.btn', 'Download', html: %r{/rails/active_storage/blobs/}
          assert_select 'time', I18n.localize(spina_structure_parts(:agm_2019_minutes_date).partable.content,
                                              format: :long)
          assert_select 'a.btn', 'Download', html: %r{/rails/active_storage/blobs/}
          assert_select 'div', spina_structure_parts(:ling_soc_cam_name).partable.content
          assert_select 'img', 1, html: %r{/rails/active_storage/representations/}
          assert_select 'div.markdown-body', spina_structure_parts(:ling_soc_cam_description).partable.content
          assert_select 'a.btn', 'Website',
                        html: /#{spina_structure_parts(:ling_soc_cam_website).partable.content}/
          assert_select 'a.btn', 'Email',
                        html: /#{spina_structure_parts(:ling_soc_cam_email_address).partable.content}/
          assert_select 'div.markdown-body', spina_page_parts(:about_page_contact).partable.content
        end
      end

      test 'visit empty about page' do
        spina_images(:dubrovnik).file.attach(io: fixture_file_upload(file_fixture('dubrovnik.jpeg')),
                                             filename: 'dubrovnik.jpeg',
                                             content_type: 'image/jpeg')
        %i[constitution agm_2019_minutes].each do |fixture|
          spina_attachments(fixture).file.attach(io: fixture_file_upload(file_fixture('blank.pdf')),
                                                 filename: 'blank.pdf',
                                                 content_type: 'application/pdf')
        end
        in_locales :en do
          get spina_pages(:empty_about).materialized_path
          assert_select 'div.markdown-body', text: spina_page_parts(:about_page_text).partable.content, count: 0
          assert_select 'a.btn', text: 'Download', count: 0
          assert_select 'time', false
          assert_select 'a.btn', text: 'Download', count: 0
          assert_select 'div', text: spina_structure_parts(:ling_soc_cam_name).partable.content, count: 0
          assert_select 'img', false
          assert_select 'div.markdown-body', text: spina_structure_parts(:ling_soc_cam_description).partable.content,
                                             count: 0
          assert_select 'a.btn', text: 'Website', count: 0
          assert_select 'a.btn', text: 'Email', count: 0
          assert_select 'div.markdown-body', false
          assert_response :success
        end
      end

      test 'visit committee page' do
        spina_images(:dubrovnik).file.attach(io: fixture_file_upload(file_fixture('dubrovnik.jpeg')),
                                             filename: 'dubrovnik.jpeg',
                                             content_type: 'image/jpeg')
        in_locales :en do
          get spina_pages(:committee).materialized_path
          assert_response :success
          assert_select 'div.markdown-body', spina_page_parts(:committee_page_text).partable.content
          assert_select 'div', /#{spina_structure_parts(:joes_profile_name).partable.content}/
          assert_select 'div', /#{spina_structure_parts(:joes_profile_role).partable.content}/
          assert_select 'div', spina_structure_parts(:joes_profile_bio).partable.content
          assert_select 'img', 1, html: %r{/rails/active_storage/representations/}
          assert_select 'a', 'Facebook',
                        html: /#{spina_structure_parts(:joes_profile_facebook_profile).partable.content}/
          assert_select 'a', 'Twitter',
                        html: /#{spina_structure_parts(:joes_profile_twitter_profile).partable.content}/
        end
      end

      test 'visit empty committee page' do
        spina_images(:dubrovnik).file.attach(io: fixture_file_upload(file_fixture('dubrovnik.jpeg')),
                                             filename: 'dubrovnik.jpeg',
                                             content_type: 'image/jpeg')
        in_locales :en do
          get spina_pages(:empty_committee).materialized_path
          assert_response :success
          assert_select 'div.markdown-body', text: spina_page_parts(:committee_page_text).partable.content, count: 0
          assert_select 'div', text: /#{spina_structure_parts(:joes_profile_name).partable.content}/, count: 0
          assert_select 'div', text: /#{spina_structure_parts(:joes_profile_role).partable.content}/, count: 0
          assert_select 'div.markdown-body', text: spina_structure_parts(:joes_profile_bio).partable.content, count: 0
          assert_select 'img', html: %r{/rails/active_storage/representations/}, count: 0
          assert_select 'a', text: 'Facebook',
                             html: /#{spina_structure_parts(:joes_profile_facebook_profile).partable.content}/,
                             count: 0
          assert_select 'a', text: 'Twitter',
                             html: /#{spina_structure_parts(:joes_profile_twitter_profile).partable.content}/,
                             count: 0
        end
      end

      test 'visit blank page' do
        in_locales :en do
          get spina_pages(:blank).materialized_path
          assert_response :success
          get spina_pages(:empty_blank).materialized_path
          assert_response :success
        end
      end

      def in_locales(*locales, include_default: true)
        yield if include_default
        locales.each do |locale|
          I18n.locale = locale
          yield
        end
      end
    end
  end
end
