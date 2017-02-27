require 'nurse/version'
require 'nurse/dependency_container'
require 'nurse/service_factory'
require 'nurse/shared_service_factory'

module Nurse
  def self.instance
    @instance ||= DependencyContainer.new
  end
end
