# frozen_string_literal: true

module Spina
  module ConferencePagesHelper
    def conference
      current_page.conference || nil
    end
    def presentation
      current_page.presentation || nil
    end
  end
end
