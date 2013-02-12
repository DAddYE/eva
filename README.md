# Eva

Eva is an effortless event driven micro framework that runs on Ruby (cruby and jruby) through
[eventmachine](http://eventmachine.rubyforge.org) with a different **syntax**.

The common problem with *EventMachine* is to deal with callbacks, fortunately thanks to
people like [Ilya Grigorik](https://github.com/igrigorik) and `things`
like [em-synchrony](https://github.com/igrigorik/em-synchrony) make this job is a little simpler but
a bit far to be _native_ like in `javascript`.

So here my idea to make **experiment** and try to figure out a new way to write better our applications
following the nature of the reactor pattern with a special focus on **simplicity** and **clearity**.


## Overview

It's **pure ruby**, no lexers and parsers. If you want a fast tast on how it looks like, 
please see [emitter](https://github.com/DAddYE/eva/blob/master/lib/eva/emitter.rb)

The _idea_ behind it is to build all our apps only using two ruby objects: `namespaces` and `objectspace`

Like in languages like `javascript` or `lua` if we have:

```js
var hello = function(){ console.log('Hello!') }
```

in order to invoke our function we should use `hello()` otherwise using only `hello` we will get
the `Function` object.

In that way is simple to chain functions and do things like:

```js
var callback = function(obj){ Notifier.sendEmail(obj) }
doExpensiveTask(var1, var2, callback)
```

So I applied the same rule on Ruby:

_unless you don't provide method arguments, invoking a method will get a Method Object instead of the result of the method itself_

Here an example:

```rb
namespace :Greater,
  say: ->(text) { p text }

Greater.say 'Hello World!'
=> "Hello World!"

Greater.say
=> #<Method: Module(Greater)#say!>
```

The main difference is that using `objectspace` and `namespace` we create
*unbounded* methods, we can still call directly these methods but appending ! (bang) prefix
or using [] or using .call

```rb
Greater.say[]
Greater.say!
Greater.say.call
```

So where this can help us?

Look a the following examples:

```rb
namespace :Circle,
  area: ->(n) do
    Math::PI * n * n
  end,

  big_calc: -> do
    perform_a_big_calc
  end

LotOfNumbers.each &Circle.area
defer Circle.big_calc
set_timeout 10, Circle.big_calc
```

## Namespaces

Namespaces are simply module **functions** a namespace looks like:

```rb
namespace :Greater,
  say: ->(text) { p [:say, text] }
```

You can extend it from another place simply invoking it:

```rb
namespace :Greater,
  say_hello: -> do
    say 'Hello There!'
  end
```

Remember that it's ruby so you can include extend other objects like:

```rb
module OldModule
  include Greater
end
```

Since is a module **function** remember you can invoke methods directly:

```rb
Greater.say 'Hello World'
Greater.say_hello! # <<<<< REMBEMBER THAT IF WE DON'T HAVE ARGUMENT TO ADD A ! or []
```

## Objectspace

Are exactly ruby classes with no exception and the structure is identical to the module

```rb
objectspace :Greater,
  say: ->(text){ p [:say, text] }
```

Also here we can add other methods whenever and wherever we want:

```rb
namespace :Greater,
  say_hello: -> do
    say 'Hello There!'
  end
```

So now we can create our Object:

```rb
greater = Greater.new
greater.say 'Hello world'
greater.say_hello! # <<<<< REMBEMBER THAT IF WE DON'T HAVE ARGUMENT TO ADD A ! or []
```

## Constructors, Private Methods, Attributes ...

In **eva** there are some special _keys_:

* `initialize`: used only for **objects**
* `include`: to include a module
* `extend`: to extend an object with the given module
* `attr_reader, attr_writer, attr_accessor, attr`: to create attributes for **objects** and **spaces**
* `alias_method`

Finally if you need to create `private` methods you can do that only prefixing with `_`

Example:

```rb
objectspace :Tester,
  attr_reader: [:a, :b, :c],
  attr_writer: [:d, :e, :f],
  attr_accessor: [:g, :h, :i],
  initialize: -> do
    @a, @b, @c = 1, 2, 3
    f = foo
    say
  end,
  foo: -> { p [:alias, :bar] },
  alias_method: { :bar => :foo },
  say: MyMod.say, # this is a delegate

Tester.new
```

## Evented

As mentioned before, the aim of this project is _play nice_ with [eventmachine](http://eventmachine.rubyforge.org),
so in _eva_ we extended the main **Object** with few and useful `delegator`:

```rb
:add_periodic_timer, :add_timer, :add_shutdown_hook, :cancel_timer,
:defer, :defers_finished?, :fork_reactor, :next_tick,
:popen, :reactor_running?, :reactor_thread?,
:schedule, :spawn, :system, :tick_loop
```

and few aliases:

```rb
alias :set_interval   :add_periodic_timer
alias :set_timeout    :add_timer
alias :clear_interval :cancel_timer
alias :clear_timeout  :cancel_timer
```

## Installation

Add this line to your application's Gemfile:

    gem 'eva'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eva

## Usage

You can use `eva` syntax in all your projects simply requiring it, if you plan to use `evented` code
so `set_timeout, defer ...` you should use `eva` executable:

```sh
eva examples/timers.rb
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Copyright

Copyright (C) 2013 Davide D'Agostino - @DAddYE

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
