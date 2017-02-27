require 'spec_helper'

describe Nurse do
  it 'has a version' do
    refute_nil ::Nurse::VERSION
  end

  describe '.instance' do
    it 'returns a singleton instance of DependencyContainer' do
      container = Nurse.instance
      container.must_be_instance_of(Nurse::DependencyContainer)
      Nurse.instance.must_be_same_as(container)
    end
  end
end
