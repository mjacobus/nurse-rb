require 'spec_helper'

describe Nurse do
  it 'has a version' do
    refute_nil ::Nurse::VERSION
  end

  describe '.dependency_manager' do
    it 'returns a singleton instance of DependencyContainer' do
      container = Nurse.dependency_manager
      container.must_be_instance_of(Nurse::DependencyContainer)
      Nurse.dependency_manager.must_be_same_as(container)
    end
  end
end
