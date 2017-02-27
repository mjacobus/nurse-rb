module Nurse
  class ServiceFactory
    def attach_to(dependency_manager)
      dependency_manager.set(dependency_key) do |di|
        create_service(di)
      end
    end

    def create_service(_dependency_manager)
      fail 'create_service must be implemented'
    end

    def dependency_key
      fail 'dependency_key must be implemented'
    end
  end
end
