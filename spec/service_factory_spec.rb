require 'spec_helper'

describe Nurse::ServiceFactory do
  let(:config) { Hash.new(foo: :bar) }

  let(:invalid_factory) do
    Class.new(Nurse::ServiceFactory).new
  end

  let(:factory) do
    Class.new(Nurse::ServiceFactory) do
      def create_service(dependency_manager)
        Array.new([dependency_manager.get(:config)])
      end

      def dependency_key
        :the_key
      end
    end
  end

  let(:container) do
    container = Nurse::DependencyContainer.new
    container.share(:config) { config }
    container.add_factory(factory.new)
    container
  end

  it 'attaches to dependency_manager' do
    service = container.get(:the_key)

    service.must_equal(Array.new([config]))
    container.get(:the_key).wont_be_same_as(service)
  end

  it 'raises error when #dependency_key is not overriden' do
    -> { invalid_factory.dependency_key }.must_raise
  end

  it 'raises error when #create_service is not overriden' do
    -> { invalid_factory.create_service([]) }.must_raise
  end
end
