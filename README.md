# Prependers

[![CircleCI](https://circleci.com/gh/nebulab/prependers.svg?style=svg)](https://circleci.com/gh/nebulab/prependers)

Prependers are a way to easily and cleanly extend third-party code via `Module#prepend`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prependers'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install prependers
```

## Usage

To define a prepender manually, simply include the `Prependers::Prepender[]` module. For instance,
if you have installed an `animals` gem and you want to extend the `Animals::Dog` class, you can
define a module like the following:

```ruby
module Animals::Dog::AddBarking
  include Prependers::Prepender[]

  def bark
    puts 'Woof!'
  end
end

Animals::Dog.new.bark # => 'Woof!'
```

### Extending class methods

If you want to extend a module's class methods, you can define a `ClassMethods` module in your
prepender:

```ruby
module Animals::Dog::AddFamily
  include Prependers::Prepender[]

  module ClassMethods
    def family
      puts 'Canids'
    end
  end
end

Animals::Dog.family # => 'Canids'
```

As you can see, the `ClassMethods` module has automagically been `prepend`ed to `Animals::Dog`'s
singleton class.

### Using a namespace

It can be useful to have a prefix namespace for your prependers. That way, you don't have to worry
about accidentally overriding any vendor modules. This is actually the recommended way to define
your prependers.

You can accomplish this by passing the `:namespace` option when including `Prependers::Prepender`:

```ruby
module MyApp
  module Animals
    module Dog
      module AddBarking
        include Prependers::Prepender[namespace: MyApp]

        # If you are autoloading prependers, use this instead:
        include Prependers::Annotate::Namespace[MyApp]

        def bark
          puts 'Woof!'
        end
      end
    end
  end
end
```

### Verifying original sources

One issue you may run into when extending third-party code is that, when the original implementation
is updated, it's not always obvious whether you have to update any of your extensions.

Prependers make this a bit easier with the concept of original source verification: you can compute
a SHA1 hash of the original implementation, store it along with your prepender, and then verify it
against the current hash when your application loads. If the original source changes, you get an
error asking you to ensure your prepender is still relevant.

To use original source verification in your prependers, pass the `:verify` option:

```ruby
module Animals::Dog::AddBarking
  include Prependers::Prepender[verify: nil]

  # If you are autoloading prependers, use this instead:
  include Prependers::Annotate::Verify['f7175533215c39f3f3328aa5829ac6b1bb168218']

  # ...
end
```

When you load your application now, you will get an error with instructions on how to set the proper
hash:

```
Prependers::OutdatedPrependerError:
  You have not defined an original hash for Animals::Dog in Animals::Dog::AddBarking.

  You can define the hash by updating your include statement as follows:

      include Prependers::Prepender[verify: 'f7175533215c39f3f3328aa5829ac6b1bb168218']
```

At this point, you should update your prepender with the correct hash:

```ruby
module Animals::Dog::AddBarking
  include Prependers::Prepender[verify: 'f7175533215c39f3f3328aa5829ac6b1bb168218']

  # ...
end
```

Now, when the underlying implementation of `Animals::Dog` changes because of a dependency update or
other reasons, Prependers will raise an error such as the following:

```
Prependers::OutdatedPrependerError:
  The stored hash for Animals::Dog in Animals::Dog::AddBarking is
  f7175533215c39f3f3328aa5829ac6b1bb168218, but the current hash is
  2f05682e4f46b509c23a8418d9427a9eeaa8a79e instead.

  This most likely means that the original source has changed.

  Check that your prepender is still valid, then update the stored hash:

      include Prependers::Prepender[verify: '2f05682e4f46b509c23a8418d9427a9eeaa8a79e']
```

Original source verification also works when a module is defined in multiple locations. 

*NOTE: Due to limitations in Ruby's API, it is not possible to use source verification with modules
that don't define any methods. Prependers will raise an error if you try to do this.*

### Autoloading prependers

If you don't want to include `Prependers::Prepender[]`, you can also autoload prependers from a
path, they will be loaded in alphabetical order.

Here's the previous example, but with autoloading:

```ruby
# app/prependers/animals/dog/add_barking.rb
module Animals::Dog::AddBarking
  def bark
    puts 'Woof!'
  end
end

# somewhere in your initialization code
Prependers.load_paths(File.expand_path('app/prependers'))
```

Note that, in order for autoprepending to work, the paths of your prependers must match the names
of the prependers you defined.

You can pass multiple arguments to `#load_paths`, which is useful if you have subdirectories in
`app/prependers`:

```ruby
Prependers.load_paths(
  File.expand_path('app/prependers/controllers'),
  File.expand_path('app/prependers/models'),
  # ...
)
```

#### Autoloading and namespaces

As you have seen in the examples for namespaces and original source verification, the syntax for
enabling these features changes slightly when you are using autoloading.

In the case of namespaces, you can also pass the `:namespace` option directly to `load_paths`, so
that you don't have to specify it for each prepender:

```ruby
Prependers.load_paths(
  File.expand_path('app/prependers/controllers'),
  File.expand_path('app/prependers/models'),
  namespace: Acme
)
```

(If you're wondering, yes, you can also do this with `:verify`, although it wouldn't make much sense
since the hash is different for each prepender.)

### Integrating with Rails

To use prependers in your Rails app, simply create them under `app/prependers/models`,
`app/prependers/controllers` etc. and add the following to your `config/application.rb`:

```ruby
Prependers.setup_for_rails
```

`#setup_for_rails` accepts the same options as `#load_paths`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nebulab/prependers.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
