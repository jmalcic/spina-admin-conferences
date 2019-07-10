# frozen_string_literal: true

module Spina
  module Conferences
    module AssetHelper #:nodoc:
      METHODS_TO_RESIZE = %i[resize_to_limit resize_to_fit resize_to_fill resize_and_pad]

      def responsive_image_tag(image, options = {})
        return if image.blank?

        options = options.symbolize_keys
        variant_options = options.delete(:variant)
        factors = options.delete(:factors) || [1, 2, 3, 4]
        options[:srcset] = get_variants(image, factors, variant_options)
        image_tag main_app.url_for(image.variant(variant_options)), options
      end

      private

      def get_variants(image, factors, options)
        factors.inject({}) do |srcset, factor|
          url = main_app.url_for(image.variant(resize_options(factor, options)))
          srcset.update(url => "#{factor}x")
        end
      end

      def resize_options(factor, options)
        options.to_h { |key, value| [key, resize_dimensions(key, factor, value)] }
      end

      def resize_dimensions(key, factor, dimensions)
        if METHODS_TO_RESIZE.include? key
          dimensions.collect { |dimension| factor * (dimension || 0) }
        else
          dimensions
        end
      end
    end
  end
end
