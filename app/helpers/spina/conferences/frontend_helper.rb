# frozen_string_literal: true

module Spina
  module Conferences
    module FrontendHelper #:nodoc:
      include WebpackHelper
      include AssetHelper

      def main_navigation(request, css: {})
        presenter = MenuPresenter.new(::Spina::Navigation.find_by(name: 'main'), request, css)
        presenter.to_html
      end

      def footer_navigation(request, css: {})
        presenter = MenuPresenter.new(::Spina::Navigation.find_by(name: 'footer'), request, css)
        presenter.to_html
      end

      def latest_conference
        Conference.sorted.first
      end
    end
  end
end
