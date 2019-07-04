# frozen_string_literal: true

module Spina
  module Conferences
    class Engine < ::Rails::Engine #:nodoc:
      isolate_namespace Spina::Conferences
      paths['public'] = 'public'

      config.before_initialize do
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
        ::Spina::PagesController.send(:include, Spina::Conferences::LoadPathExtensions)
        page_partables.each { |partable| partable.send(:include, Spina::Conferences::AssociationExtensions) }
        ::Spina::Option.send(:include, Spina::Conferences::OptionExtensions)
        ::Spina::Structure.send(:include, Spina::Conferences::StructureExtensions)
      end

      config.after_initialize do
        @webpacker = ::Webpacker::Instance.new root_path: root, config_path: root.join('config/webpacker.yml')
      end

      config.app_middleware.use ::ActionDispatch::Static, paths['public'].first

      class << self
        attr_reader :webpacker
      end
    end
  end
end
