module Nurse
  class DependencyContainer
    class UndefinedDependency < RuntimeError; end
    class DependencyAlreadyDefined < RuntimeError; end

    def define(dependency, &block)
      ensure_undefined(dependency)
      definitions[to_key(dependency)] = block
      self
    end

    def define!(dependency, &block)
      undefine(dependency)
      define(dependency, &block)
    end

    def defined?(dependency)
      definitions.has_key?(to_key(dependency))
    end

    def get(dependency)
      return nil unless self.defined?(dependency)

      key = to_key(dependency)

      unless instances.has_key?(key)
        instances[key] = definitions[key].call(self)
      end

      instances[key]
    end

    def fetch(dependency, &block)
      return get(dependency) if self.defined?(dependency)
      return block.call(dependency) if block_given?
      raise UndefinedDependency, "'#{dependency}' was not defined"
    end

    private

    def ensure_undefined(dependency)
      if self.defined?(to_key(dependency))
        raise DependencyAlreadyDefined.new(
          "Dependency '#{dependency}' was already defined"
        )
      end
    end

    def instances
      @instances ||= {}
    end

    def definitions
      @definitions ||= {}
    end

    def to_key(object)
      object.to_s.to_sym
    end

    def undefine(dependency)
      return unless self.defined?(dependency)
      key = to_key(dependency)
      definitions.delete(key)
      instances.delete(key)
    end
  end
end
