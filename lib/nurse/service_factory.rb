module Nurse
  class ServiceFactory
    def attach_to(dependency_manager)
      if shared?
        dependency_manager.share(dependency_key) do |di|
          create_service(di)
        end

        return
      end

      dependency_manager.set(dependency_key) do |di|
        create_service(di)
      end
    end

    def create_service(_dependency_manager)
      raise 'create_service must be implemented'
    end

    def dependency_key
      raise 'dependency_key must be implemented'
    end

    def shared?
      false
    end

    class << self
      private

      def share(boolean)
        instance_eval do
          define_method :shared? do
            boolean
          end
        end
      end

      def key(dependency_key)
        instance_eval do
          define_method :dependency_key do
            dependency_key
          end
        end
      end
    end
  end
end
