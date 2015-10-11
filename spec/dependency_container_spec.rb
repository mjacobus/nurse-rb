require "spec_helper"

describe Nurse::DependencyContainer do
  let(:container) do
    container = Nurse::DependencyContainer.new

    container.define(Hash) do
      Hash.new
    end

    container.define(:definition) do
      :defined_object
    end
  end

  describe "#define" do
    it "defines dependencies" do
      container.define(:foo) do
        :bar
      end

      container.get(:foo).must_equal :bar
    end

    it "passess the container as argument for the block" do
      container.define(:hash) do |di|
        { name: di.get(:name) }
      end

      container.define :name do
        "marcelo"
      end

      container.get(:hash)[:name].must_equal("marcelo")
    end

    it "throws an exception if dependency was already defined" do
      begin
        container.define(Hash)
        fail
      rescue Nurse::DependencyContainer::DependencyAlreadyDefined => e
        e.message.must_equal "Dependency 'Hash' was already defined"
      end
    end
  end

  describe "#define!" do
    it "overrites definition" do
      container.define!(:dependency) { :bar }
      container.get(:dependency).must_equal :bar

      container.define!(:dependency) do
        # { foo: di.get(:dependency) }
        :new_dependency
      end

      container.get(:dependency).must_equal(:new_dependency)
    end
  end

  describe "#defined?" do
    it "returns false when dependency was not defined" do
      container.defined?(:foo).must_equal false
    end

    it "returns true when dependency was defined" do
      container.defined?(Hash).must_equal true
    end

    it "handles classes as dependencies keys" do
      container.defined?(Hash).must_equal true
    end

    it "handles symbols as dependencies keys" do
      container.defined?(:definition).must_equal true
    end

    it "handles strings as dependencies keys" do
      container.defined?("definition").must_equal true
    end
  end

  describe "#get" do
    it "return nil when no dependency was defined" do
      container.get(:undefined).must_equal nil
    end

    it "returns a unique instance of the dependency when it was defined" do
      dependency = container.get(Hash)
      dependency.must_be_instance_of(Hash)
      container.get(Hash).must_be_same_as(dependency)
    end
  end

  describe "#fetch" do
    it "returns a unique instance of the dependency when it was defined" do
      dependency = container.fetch(Hash)
      dependency.must_be_instance_of(Hash)
      container.fetch(Hash).must_be_same_as(dependency)
    end

    it "throws an exception when dependency is not defined" do
      begin
        container.fetch("undefined")
        fail
      rescue Nurse::DependencyContainer::UndefinedDependency => e
        e.message.must_equal "'undefined' was not defined"
      end
    end

    it "allows block as a fall back for the unexisting dependency" do
      container.fetch("undefined") do |key|
        "#{key} undefined"
      end.must_equal "undefined undefined"

      container.fetch("undefined") { "undefined" }.must_equal "undefined"
    end
  end
end
