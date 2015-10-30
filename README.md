# FlockSynchronize

This gem allows synchronization of code across multiple processes on POSIX 
systems using flock, similar to how Mutexes work for Ruby threads.

Wrapping your code in `FlockSynchronize.flock_synchronize` will create a
filesystem lock for a given string key. All processes synchronized with the
same key will wait for each other.

For example:

```
FlockSynchronize.flock_synchronize("mykey") do
   some_code_that_needs_to_be_synchronized()
end
```

**Note**: This only works with multiple processes, and not with multiple Ruby
threads. If you want the same behaviour with threads, look at the built-in
Mutex class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flock_synchronize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flock_synchronize

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fishpercolator/flock_synchronize

