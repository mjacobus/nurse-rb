require 'nurse/version'
require 'nurse/dependency_container'

module Nurse
  def self.instance
    @instance ||= DependencyContainer.new
  end
end
