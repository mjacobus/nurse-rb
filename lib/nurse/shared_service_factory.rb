module Nurse
  class SharedServiceFactory < ServiceFactory
    def shared?
      true
    end

    class << self
      private

      def share(_shared)
        raise 'You cannot change the shared state of a shared service factory. Extend Nurse::ServiceFactory instead'
      end
    end
  end
end
