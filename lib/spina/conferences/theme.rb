# frozen_string_literal: true

module Spina
  module Conferences
    class Theme
      @themes = []

      class << self
        attr_accessor :themes
      end

      def self.register
        theme = Theme.new
        yield theme
        raise 'Missing theme name' if theme.name.nil?

        @themes << theme
      end

      def self.find_by(name: nil)
        @themes.bsearch { |theme| theme.name == name }
      end

      attr_accessor :name, :models

      def initialize
        @models = []
      end
    end
  end
end
