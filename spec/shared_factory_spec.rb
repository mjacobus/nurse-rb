require 'spec_helper'

describe Nurse::ServiceFactory do
  let(:config) { Hash.new(foo: :bar) }

  let(:factory) do
    Class.new(Nurse::SharedServiceFactory) do
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
    container.get(:the_key).must_be_same_as(service)
  end

  it 'extends ServiceFactory' do
    factory.new.is_a?(Nurse::ServiceFactory).must_equal true
  end
end
