# frozen_string_literal: true

module Spina
  module Conferences
    class Theme
      attr_accessor :name, :parts, :models

      class << self
        def find_by_name(name)
          ::Spina::Conferences::THEMES.find { |theme| theme.name == name }
        end

        def register
          theme = ::Spina::Conferences::Theme.new
          yield theme
          raise 'Missing theme name' if theme.name.nil?

          ::Spina::Conferences::THEMES << theme
        end
      end

      def initialize
        @parts = []
        @models = []
      end
    end
  end
end
