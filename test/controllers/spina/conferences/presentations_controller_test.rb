# frozen_string_literal: true

require 'test_helper'

module Spina
  module Conferences
    class PresentationsControllerTest < ActionDispatch::IntegrationTest
      include ::Spina::Engine.routes.url_helpers

      setup do
        @presentation = spina_conferences_presentations :asymmetry_and_antisymmetry
      end

      test 'should get index' do
        get conferences_presentations_url(format: :ics)
        assert_response :success
      end

      test 'should show presentation' do
        get conferences_presentation_url(@presentation, format: :ics)
        assert_response :success
      end
    end
  end
end
