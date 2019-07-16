# frozen_string_literal: true

module Spina
  module Conferences
    module MetadataHelper #:nodoc:
      delegate :description, :seo_title, :menu_title, to: :metadata_object
    end
  end
end
