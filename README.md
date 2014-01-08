Logick
=====

Why?
---

To ensure separation of business logic and whatever uses business logic.
(such as a web framework, a command line interface, or a test)

All business logic should be defined within perform blocks.(i.e. perform a block of code)
You should be able to define your business logic linearly using error handlers to
exit early and return failed results. If the business logic finishes as expected
then the result is wrapped in successful result object.

Usage
-----

Define your class like this:

    class A

      attr_accessor :foo

      def valid?
        self.foo != ""
      end

      def execute!
        do_something_important!(foo: self.foo)
      end
    end


Then you can use it like this:

    result = Logic.perform do
      a = A.new("foo!")
      handle(a.valid?){ error("the foo was invalid.") }
      a.execute!
    end

    if result.success?
      puts "did something and here is the result: #{result.payload}"
    else
      puts "invalid A. Here's the error: #{result.payload}"
    end


### Using with Scrivener

Define an object like so.

    class A < Scrivener

      attr_accessor :foo

      def validate
        assert(foo.size > 0, [:foo, :is_blank])
      end

      def execute!
        do_something_important!(foo: self.foo)
      end
    end

Use it like this:

    result = Logic.perform {
      a = A.new(foo: "foo!")
      handle(a.valid?){ error(a) }
      a.execute!
      a
    }

    if result.success?
      puts "Success! Result: #{result.payload}"
    else
      puts "Failed. Here's the Error: #{result.payload.errors}"
    end



### Perform Blocks

Logic.perform performs a block of code and returns a Result object. The
result object has Result#success? (also Result#failed?) method which users can use to
determine whether the performed business logic was successful or not.

It also provides the following helper methods to handle errors:

- Logic.error(some_object)

  This will exit the block early and Logic.perform will return a failed result
  with some_object as its payload

- Logic.guard(predicate)

  This will check the predicate. If false, it will exit the block early and
  Logic.perform will return a failed result with nil as the payload. If true,
  it proceeds to the next line of code

  This is almost identical to:

    Logic.handle(predicate){ error(nil) }

- Logic.handle(predicate, &block)

  This will check the predicate. If false, it will execute the block and return
  its result. If true, it just proceeds to the next line of code
