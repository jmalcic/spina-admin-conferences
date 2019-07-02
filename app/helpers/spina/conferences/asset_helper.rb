# frozen_string_literal: true

module Spina
  module Conferences
    module AssetHelper #:nodoc:
      def responsive_image_tag(image, options = {})
        return if image.blank?

        options = options.symbolize_keys
        variant_options = options.delete(:variant)
        factors = options.delete(:factors) || [1, 2, 3, 4]
        variants = process_variant_options(image, factors, variant_options)
        options[:srcset] = variants.inject(&:merge)
        image_tag main_app.url_for(image.variant(variant_options)), options
      end

      def process_variant_options(image, factors, variant_options)
        methods = %i[resize_to_limit resize_to_fit resize_to_fill resize_and_pad]
        unprocessed_options = variant_options.select { |key| methods.include? key }
        factors.collect do |factor|
          processed_options = unprocessed_options.transform_values { |value| multiply_factor(factor, value) }
          { main_app.url_for(image.variant(variant_options.merge(processed_options))) => "#{factor}x" }
        end
      end

      def multiply_factor(factor, geometry)
        [(geometry[0]&.* factor), (geometry[1]&.* factor)]
      end
    end
  end
end
