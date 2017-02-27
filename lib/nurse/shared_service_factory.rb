module Nurse
  class SharedServiceFactory < ServiceFactory
    def attach_to(dependency_manager)
      dependency_manager.share(dependency_key) do |di|
        create_service(di)
      end
    end
  end
end
