# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class PresentationAttachmentTypeTest < ActiveSupport::TestCase
        setup { @presentation_attachment_type = spina_admin_conferences_presentation_attachment_types :handout }

        test 'translates name' do
          @presentation_attachment_type.name = 'foo'
          I18n.locale = :ja
          assert_equal 'foo', @presentation_attachment_type.name
          @presentation_attachment_type.name = 'bar'
          assert_equal 'bar', @presentation_attachment_type.name
          I18n.locale = I18n.default_locale
          assert_equal 'foo', @presentation_attachment_type.name
        end

        test 'presentation attachment type attributes must not be empty' do
          presentation_attachment_type = PresentationAttachmentType.new
          assert presentation_attachment_type.invalid?
          assert presentation_attachment_type.errors[:name].any?
        end
      end
    end
  end
end
