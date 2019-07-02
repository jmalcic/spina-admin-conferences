# frozen_string_literal: true

module Spina
  module Conferences
    module FrontendHelper #:nodoc:
      include WebpackHelper
      include AssetHelper

      def main_navigation(menu_css, link_tag_css, inactive_link_tag_css, request)
        presenter = MenuPresenter.new(::Spina::Navigation.find_by(name: 'main'), request)
        presenter.menu_css = menu_css
        presenter.link_tag_css = link_tag_css
        presenter.inactive_link_tag_css = inactive_link_tag_css
        presenter.to_html
      end

      def footer_navigation(menu_css, link_tag_css, inactive_link_tag_css, request)
        presenter = MenuPresenter.new(::Spina::Navigation.find_by(name: 'footer'), request)
        presenter.menu_css = menu_css
        presenter.link_tag_css = link_tag_css
        presenter.inactive_link_tag_css = inactive_link_tag_css
        presenter.to_html
      end

      def latest_conference
        Conference.sorted.first
      end

      def raw_part(name)
        @page.page_parts.find_by(name: name)
      end
    end
  end
end
