# frozen_string_literal: true

module Stimulus
  class DataMap #:nodoc:
    def initialize(map)
      @native = Native(map)
    end

    def [](key)
      @native.get(key.camelize(false))
    end

    def []=(key, value)
      @native.set(key.camelize(false), value)
    end

    def delete(key)
      @native.delete(key.camelize(false))
    end

    def include?(key)
      @native.has(key.camelize(false))
    end

    alias member? include?
  end
end
