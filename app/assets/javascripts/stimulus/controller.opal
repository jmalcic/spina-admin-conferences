# frozen_string_literal: true

module Stimulus
  class Controller #:nodoc:
    @targets = []
    @filters = {}

    class << self
      include Native::Helpers

      attr_reader :targets
      attr_reader :filters

      %i[initialize connect disconnect].each do |filter|
        define_method "after_#{filter}" do |*methods|
          add_filter filter, methods
        end
      end
    end

    def self.inherited(subclass)
      subclass.instance_variable_set :@targets, @targets
      subclass.instance_variable_set :@filters, @filters
    end

    def self.has_targets(*targets)
      targets.each { |target| @targets << target }
    end

    def self.add_filter(name, methods)
      @filters[name] = methods
    end

    def self.identifier
      name.chomp('Controller').dasherize
    end

    attr_reader :native_class

    native_reader :application, :element

    def initialize
      @native_class = %x(class extends Stimulus.Controller {
        constructor(...args) {
          super(...args)
          #{@native} = this
          #{alias_data_map}
          #{alias_targets}
        }
      })
      set_targets
      append_methods
    end

    def set_targets
      %x(Object.defineProperty(#{@native_class}, 'targets', {
        get() { return #{self.class.targets.collect do |target|
        target.camelize(false)
      end}
      }}))
    end

    def append_methods
      append_instance_methods
      append_filters
    end

    def append_instance_methods
      self.class.instance_methods(true).each do |method|
        append_method(method(method)) unless method == :initialize
      end
    end

    def append_filters
      self.class.filters.each do |name, methods|
        append_proc(name) do |*args|
          methods.each { |method| method(method).call(args) }
        end
      end
    end

    def append_method(method, name = method.name)
      append_proc(name) do |event, *args|
        event = Browser::Event.new(event)
        method.call(event, args)
      end
    end

    def append_proc(name)
      %x(#{@native_class}.prototype[#{name.camelize(false)}] =
        function(...args) {
          return #{yield(*`args`)}
      })
    end

    def alias_data_map
      @data = DataMap.new(`#{@native}.data`)
      define_singleton_method(:data) { @data }
    end

    def alias_targets
      self.class.targets.each do |target|
        target = "#{target}_target"
        [target, target.pluralize, "has_#{target}?"].each do |method|
          define_singleton_method method do
            Native(`#{@native}[#{method.delete('!?').camelize(false)}]`)
          end
        end
      end
    end
  end
end
