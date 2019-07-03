# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PresentationsControllerTest < ActionDispatch::IntegrationTest
      include ::Spina::Engine.routes.url_helpers

      setup { @presentation = spina_conferences_presentations :asymmetry_and_antisymmetry }

      test 'should show presentation' do
        get conferences_presentation_url(@presentation)
        assert_response :success
      end

      test 'should show presentation as ics' do
        get conferences_presentation_url(@presentation, format: :ics)
        assert_response :success
      end
    end
  end
end
