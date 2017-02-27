require 'spec_helper'

describe Nurse::DependencyContainer do
  let(:shared) { Hash.new }
  let(:new_hash) { Hash.new(foo: :bar) }

  let(:container) do
    container = Nurse::DependencyContainer.new
    container.share(Hash) { Hash.new }
    container.share(:definition) { :defined_object }
    container.share(:shared) { shared }
    container.set(:new_hash) { new_hash.dup }
  end

  describe '#defined?' do
    it 'returns false when it was not defined' do
      container.defined?(:undefined).must_equal(false)
    end

    it 'returns true when it was defined with #share' do
      container.defined?(:shared).must_equal(true)
      container.defined?('shared').must_equal(true)
    end

    it 'returns true when it was defined with #set' do
      container.defined?(:new_hash).must_equal(true)
      container.defined?('new_hash').must_equal(true)
    end
  end

  describe '#share' do
    it 'raises error when dependency is already defined' do
      begin
        container.share(:shared)
        fail
      rescue Nurse::DependencyContainer::DependencyAlreadyDefined => e
        e.message.must_equal "Dependency 'shared' was already defined"
      end
    end
  end

  describe '#set' do
    it 'raises error when dependency is already defined' do
      begin
        container.share(:new_hash)
        fail
      rescue Nurse::DependencyContainer::DependencyAlreadyDefined => e
        e.message.must_equal "Dependency 'new_hash' was already defined"
      end
    end
  end

  describe '#get' do
    it 'returns the same instance when it was defined with #share' do
      container.get(:shared).must_be_same_as(shared)
      container.get(:shared).must_be_same_as(container.get(:shared))
    end

    it 'returns a different instance when it was defined with #set' do
      container.get(:new_hash).wont_be_same_as(new_hash)
      container.get(:new_hash).must_equal(new_hash)
      container.get('new_hash').must_equal(new_hash)
    end

    it 'returns block if dependency is not defined and block is given' do
      container.get(:undefined) { :foo }.must_equal :foo
    end

    it 'raises an exception when dependency is not defined' do
      begin
        container.get('undefined')
        fail
      rescue Nurse::DependencyContainer::UndefinedDependency => e
        e.message.must_equal "'undefined' was not defined"
      end
    end
  end
end
