# frozen_string_literal: true

module Spina
  module Conferences
    # This class represents email addresses. The format is validated.
    class EmailAddressPart < ApplicationRecord
      has_many :page_parts, as: :page_partable
      has_many :layout_parts, as: :layout_partable
      has_many :structure_parts, as: :structure_partable

      validates :content, email_address: true, unless: proc { |a| a.content.blank? }
    end
  end
end
