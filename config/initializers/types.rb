# frozen_string_literal: true

require 'spina/admin/conferences/types/interval_type'

ActiveRecord::Type.register :interval, Spina::Admin::Conferences::IntervalType, adapter: :postgresql

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
  alias_method :configure_connection_without_interval, :configure_connection
  define_method :configure_connection do
    configure_connection_without_interval
    execute 'SET IntervalStyle = iso_8601', 'SCHEMA'
  end
end
