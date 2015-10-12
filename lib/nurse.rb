require "nurse/version"
require "nurse/dependency_container"

module Nurse
  def self.dependency_manager
    @@dependency_manager ||= DependencyContainer.new
  end
end
