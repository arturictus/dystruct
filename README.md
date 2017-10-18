# Dystruct

Better Structs for many applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dystruct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dystruct

## Usage

__Extended OpenStruct:__

```ruby
  context = Dystruct.new(name: 'John', surname: 'Doe')
  context.name # => 'John'
  context.name_provided? # => true
  context.surname # => 'Doe'
  context.foo_provided? # => false
  context.foo_not_provided? # => true
  context.foo = :bar
  context.foo_provided? # => true
  context.foo_not_provided? # => false
  context.foo # => :bar
  context.to_h # => {:name=>"John", :surname=>"Doe", :foo=>:bar}
```

_more complex example_
```ruby
class Input < Dystruct
  permit  :name, :city, :address, :phone_number, :free_text, :country_code,
    :country, :zip, :types
  defaults types: ['lodging']
  aliases :name, :hotel_name
  aliases :phone_number, :telephone

  def long_name
    [name, address, city].join(', ')
  end

  def types
    Array.wrap(args[:types])
  end
end

i = Input.new(name: 'Hotel', city: 'Barcelona', address: 'Happy street', not_permitted: 'dangerous')
i.types
# => ["lodging"]
i.long_name
# => "Hotel, Happy street, Barcelona"
i.name
# => "Hotel"
i.hotel_name
# => "Hotel"
i.phone_number_provided?
# => false
i.not_permitted
# => NoMethodError: undefined method
```

### Building better Structs

**no_method_error**
```ruby
class Example < Dystruct
  no_method_error false
end

Example.new(foo: :bar).hello # => nil
```

```ruby
class Example < Dystruct
  no_method_error
end

Example.new(foo: :bar).hello # => => NoMethodError: undefined method
```

**required**
```ruby
class Example < Dystruct
  required :required_arg
end

Example.new(foo: :bar)
#=> Error Dystruct::RequiredFieldNotPresent
```

**aliases**
```ruby
class Example < Dystruct
  aliases :hello, :greeting, :welcome
end
ex = Example.new(hello: 'Hey!')
# => #<Example:0x007fd88ba30398 @args={:hello=>"Hey!"}>
ex.hello
# => "Hey!"
ex.greeting
# => "Hey!"
ex.welcome
# => "Hey!"
```

**defaults**
```ruby
class Example2 < Dystruct
  defaults foo: :bar, bar: :foo
end
ex = Example2.new
ex.foo
# => :bar
ex.bar
# => :foo
ex.foo = :hello
ex.foo
# => :hello

ex2 = Example2.new(foo: 'something', bar: true)
ex2.foo
# => 'something'
ex2.bar
# => true
```

**ensure_presence**
```ruby
class EnsurePresence < Dystruct
  ensure_presence :foo
end
EnsurePresence.new(hello: 'asdf')
#=> Error: Dystruct::PresenceRequired

EnsurePresence.new(foo: nil)
#=> Error: Dystruct::PresenceRequired

EnsurePresence.new(foo: '').foo #=> ""
```

**permit**
```ruby
per = Permit.new(foo: :bar, hello: 'Hey!', bar: 'bla', yuju: 'dangerous')
 => #<Permit:0x007fd88b9dd878 @args={:foo=>:bar, :hello=>"Hey!"}>
per.foo #=> :bar
per.yuju #=> nil
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arturictus/dystruct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
