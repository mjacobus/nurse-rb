module Nurse
  # The dependency container class
  class DependencyContainer
    class UndefinedDependency < RuntimeError; end
    class DependencyAlreadyDefined < RuntimeError; end

    def initialize
      @factories = {}
      @shared_factories = {}
      @instances = {}
    end

    def share(dependency, &block)
      ensure_undefined(dependency)
      shared_factories[to_key(dependency)] = block
      self
    end

    def set(dependency, &block)
      ensure_undefined(dependency)
      factories[to_key(dependency)] = block
      self
    end

    def defined?(dependency)
      key = to_key(dependency)
      shared_factories.key?(key) || factories.key?(key)
    end

    def get(dependency, &_block)
      key = to_key(dependency)

      if self.defined?(key)
        return from_shared_factories(key) || from_factories(key)
      end

      return yield if block_given?

      fail UndefinedDependency, "'#{dependency}' was not defined"
    end

    protected

    attr_reader :factories
    attr_reader :instances
    attr_reader :shared_factories

    def from_shared_factories(key)
      return unless shared_factories.key?(key)
      instances[key] ||= shared_factories[key].call(self)
    end

    def from_factories(key)
      factories[key].call(self) if factories.key?(key)
    end

    def ensure_undefined(dependency)
      return unless self.defined?(dependency)
      fail DependencyAlreadyDefined,
           "Dependency '#{dependency}' was already defined"
    end

    def to_key(object)
      object.to_s
    end
  end
end
