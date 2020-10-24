# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      module Migration
        class RenamingTest < ActiveSupport::TestCase
          setup do
            @dummy_class = Class.new(Rails::Railtie) do
              class << self
                attr_accessor :stale_migrations
                attr_accessor :migrations_path
              end
            end
          end

          test 'initializes stale migrations array' do
            assert_nil @dummy_class.stale_migrations
            @dummy_class.include(Renaming)
            assert_equal [], @dummy_class.stale_migrations
          end

          test 'adds stale migrations when declared' do
            @dummy_class.migrations_path = file_fixture('migrations/stale').to_path
            @dummy_class.include(Renaming)
            assert_empty @dummy_class.stale_migrations
            @dummy_class.rename_migration 'old_name', to: 'new_name'
            assert_not_empty @dummy_class.stale_migrations
          end

          test 'does not add fresh migrations when declared' do
            @dummy_class.migrations_path = file_fixture('migrations/fresh').to_path
            @dummy_class.include(Renaming)
            assert_empty @dummy_class.stale_migrations
            @dummy_class.rename_migration 'old_name', to: 'new_name'
            assert_empty @dummy_class.stale_migrations
          end

          test 'raises on duplicate migrations' do
            @dummy_class.include(Renaming)
            @dummy_class.stale_migrations = [
              {
                old: { name: 'old_name', file: '00000000000000_old_name.spina_conferences.rb' },
                new: { name: 'new_name', file: '00000000000000_new_name.spina_conferences.rb' }
              }
            ]
            assert_raises Renaming::DuplicateMigrationsError do
              @dummy_class.raise_on_duplicate_migrations!
            end
          end

          test 'does not raise on empty migrations' do
            @dummy_class.include(Renaming)
            @dummy_class.stale_migrations = []
            assert_nothing_raised do
              @dummy_class.raise_on_duplicate_migrations!
            end
          end
        end
      end
    end
  end
end
