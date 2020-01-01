# frozen_string_literal: true

module Spina
  module Conferences
    class Engine < ::Rails::Engine #:nodoc:
      isolate_namespace Spina::Conferences

      config.before_initialize do
        ::Spina::Theme.include Spina::Conferences::ThemeExtensions
        ::Spina::Plugin.register do |plugin|
          plugin.name = 'conferences'
          plugin.namespace = 'conferences'
        end
      end

      config.to_prepare do
        # Add patches
        page_partables = [::Spina::Attachment, ::Spina::AttachmentCollection, ::Spina::Image, ::Spina::ImageCollection,
                          ::Spina::Line, ::Spina::Option, ::Spina::Structure, ::Spina::Text]
        page_partables.each { |partable| partable.include Spina::Conferences::PartableExtensions }
        ::Spina::Option.include Spina::Conferences::OptionExtensions
        ::Spina::Structure.include Spina::Conferences::StructureExtensions
        ::Spina::Admin::PagesHelper.include Spina::Admin::Conferences::PagesHelperExtensions
      end
    end
  end
end
