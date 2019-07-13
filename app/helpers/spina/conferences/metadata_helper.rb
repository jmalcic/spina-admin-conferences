# frozen_string_literal: true

module Spina
  module Conferences
    module MetadataHelper #:nodoc:
      delegate :seo_description, :seo_title, :menu_title, to: :metadata_object
    end
  end
end
