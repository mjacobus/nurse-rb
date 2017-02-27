# Nurse

Nurse, for your dependency injection

Code quality

[![Build Status](https://travis-ci.org/mjacobus/nurse-rb.svg)](https://travis-ci.org/mjacobus/nurse-rb)
[![Coverage Status](https://coveralls.io/repos/github/mjacobus/nurse/badge.svg?branch=master)](https://coveralls.io/github/mjacobus/nurse?branch=master)
[![Code Coverage](https://scrutinizer-ci.com/g/mjacobus/nurse-rb/badges/coverage.png?b=master)](https://scrutinizer-ci.com/g/mjacobus/nurse-rb/?branch=master)
[![Code Climate](https://codeclimate.com/github/mjacobus/nurse-rb/badges/gpa.svg)](https://codeclimate.com/github/mjacobus/nurse-rb)
[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/mjacobus/nurse-rb/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/mjacobus/nurse-rb/?branch=master)

Package information

[![Dependency Status](https://gemnasium.com/mjacobus/nurse-rb.svg)](https://gemnasium.com/mjacobus/nurse-rb)
[![Gem Version](https://badge.fury.io/rb/nurse-rb.svg)](https://badge.fury.io/rb/nurse-rb)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nurse-rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nurse-rb

## Usage

### Defining dependencies

```ruby
dependency_manager = Nurse::DependencyContainer.new

dependency_manager.share(:connection) do |dependency_manager|
  MyConnection.new("mysql://root@localhost/my_db")
end

dependency_manager.share(UserRepository) do |dependency_manager|
  connection = dependency_manager.get(:connection)
  UserRepository.new(connection)
end
```

Also, you can use the singleton instance. Use singleton if you do not have
control over how classes, such as controllers, are created.

```ruby
dependency_manager = Nurse.instance
```

### Fetching dependencies
```ruby
class UsersController < SomeBaseController
  def index
    @users = repository.find_all
  end

  private

  def repository
    dependency_manager.get(UserRepository)
  end
end
```

```ruby
class DatabaseConnectionFactory < Nurse::SharedServiceFactory
  def create_service(dependencies)
    DatabaseConnection.new(dependencies.get(:db_config))
  end

  def dependency_key
    :db_connection
  end
end

class UserRepositoryFactory < Nurse::ServiceFactory
  def create_service(dependencies)
    UserRepository.new(dependencies.get(:db_connection))
  end

  def dependency_key
    :user_repository
  end
end

dependency_manager.add_factory(DatabaseConnectionFactory.new)
dependency_manager.add_factory(UserRepositoryFactory.new)
```

### Using factories

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mjacobus/nurse-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

