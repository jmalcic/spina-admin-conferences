# frozen_string_literal: true

module Spina
  module Conferences
    class Engine < ::Rails::Engine #:nodoc:
      isolate_namespace Spina::Conferences

      config.before_initialize do
        ::Spina::Theme.send(:include, Spina::Conferences::ThemeExtensions)
        ::Spina::Plugin.register do |plugin|
          plugin.name = 'conferences'
          plugin.namespace = 'conferences'
        end
      end

      config.to_prepare do
        # Load helpers from engine
        ::Spina::Admin::AdminController.helper 'spina/admin/conferences/application'
        ::Spina::PagesController.helper 'spina/conferences/pages'
        # Add patches
        page_partables = [::Spina::Attachment, ::Spina::AttachmentCollection, ::Spina::Image, ::Spina::ImageCollection,
                          ::Spina::Line, ::Spina::Option, ::Spina::Structure, ::Spina::Text]
        ::Spina::PagesController.send(:include, Spina::Conferences::Templatable)
        page_partables.each { |partable| partable.send(:include, Spina::Conferences::PartableExtensions) }
        ::Spina::Option.send(:include, Spina::Conferences::OptionExtensions)
        ::Spina::Structure.send(:include, Spina::Conferences::StructureExtensions)
        ::Spina::Admin::PagesHelper.send(:include, Spina::Admin::Conferences::PagesHelperExtensions)
      end
    end
  end
end
