require 'spec_helper'

describe Nurse::ServiceFactory do
  let(:config) { Hash.new(foo: :bar) }

  let(:invalid_factory) do
    Class.new(Nurse::ServiceFactory).new
  end

  let(:factory) do
    Class.new(Nurse::ServiceFactory) do
      key :the_key

      def create_service(dependency_manager)
        Array.new([dependency_manager.get(:config)])
      end
    end
  end

  let(:shared_factory) do
    Class.new(Nurse::ServiceFactory) do
      share true
      key :shared_key

      def create_service(dependency_manager)
        Array.new([dependency_manager.get(:config)])
      end
    end
  end

  let(:container) do
    container = Nurse::DependencyContainer.new
    container.share(:config) { config }
    container.add_factory(factory.new)
    container.add_factory(shared_factory.new)
    container
  end

  describe 'when it is not a shared dependency' do
    it 'attaches to dependency_manager' do
      service = container.get(:the_key)

      service.must_equal(Array.new([config]))
      container.get(:the_key).wont_be_same_as(service)
    end

    it 'is not shared?' do
      factory.new.shared?.must_equal false
    end

    it 'raises error when #dependency_key is not overriden' do
      -> { invalid_factory.dependency_key }.must_raise
    end

    it 'raises error when #create_service is not overriden' do
      -> { invalid_factory.create_service([]) }.must_raise
    end
  end

  describe 'when it is shared' do
    it 'attaches to dependency_manager as a non shared resource' do
      service = container.get(:shared_key)

      service.must_equal(Array.new([config]))
      container.get(:shared_key).must_be_same_as(service)
    end

    it 'extends ServiceFactory' do
      shared_factory.new.is_a?(Nurse::ServiceFactory).must_equal true
    end

    it 'is shared' do
      shared_factory.new.shared?.must_equal true
    end
  end
end
