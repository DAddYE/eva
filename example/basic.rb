require 'bundler/setup'
require 'eva'

# The first difference is that namespace returns
# a module function.
#
# The second main difference is that using
# objectspace and namespace we create
# *unbounded* methods, we can still call
# directly these methods but appending ! (bang)
# or using [] or using .call
#
#   # Examples:
#   Greater.say[]
#   Greater.say!
#   Greater.say.call
#   Greater.say # => method(:say!)
#
# But if we provide arguments this is not necessary
#
#   Greater.say 'Foo'
#   # is equal to
#   Greater.say! 'Foo'
#
# This patternis well know in javascript where having:
#
#   function myFunction(){ doSome }
#
# you should *always* call it with parenthesis if not:
#
#   a = myFunction
#   # will returns: [Function: MyFunction]
#
# This pattern, applied with eventmachine, enumerator, callbacks
# etc opens the doors to method chainability and fun stuff ;)
#
# Private methods starts with underscore:
#
#   namespace :Foo,
#     im_public: -> {}
#     _im_private: -> {}
#
# You can also use module methods like:
#
# * attr
# * attr_reader
# * attr_writer
# * attr_accessor
# * alias_method
# * alias
#

##
# Namespaces
#
namespace :Greater,
  say: ->(text) { p [:say, text] }

# If we have params
Greater.say 'Hey'

# if we want we can add methods
# to that module space ... also **private**
namespace :Greater,
  hello: -> { say! 'Hello from Greater!!' },
  _not_public: -> {}

Greater.hello!
Greater.not_public! rescue p([:not_public, 'is private'])

##
# Classes
#
objectspace :Foo,
  say: ->(text){ p [:say, text] }

# we can add methods whenever we want
objectspace :Foo,
  initialize: -> { say! 'Hello from Foo!!' }
  # initialize, include and extend ATM are reserved words so (no-bang)
  # include: Mod # works too
  # extend: Mod  # will works too (if we were in a module)

Foo.new

# we can inherit classes
objectspace :Bar => Foo,
  hello: -> { say! 'Hello from Bar!!' }

Bar.new.hello!
#.new will greet Foo and then Bar

# We can include namespace in other modules
module MyMod
  include Greater
end

MyMod.say! 'Hello from MyMod!!'

# And so also in classes
class MyClass
  include Greater
end

MyClass.new.say! 'Hello from MyClass!!'

##
# Aliases, Delegate && Attributes
#
namespace :Aliases,
  attr_reader: [:a, :b, :c],
  attr_writer: [:d, :e, :f],
  attr_accessor: [:g, :h, :i],
  foo: -> { p [:alias, :bar] },
  alias_method: { :bar => :foo },
  say: MyMod.say, # this is a delegate
  assert: -> {
    @a, @b, @c = 1, 2, 3
    say a
    say b
    say c
    self.d, self.e, self.f = 4, 5, 6
    say @d
    say @e
    say @f
    @g, @h, @i = 7, 8, 9
    say g
    say h
    say i
    self.g, self.h, self.i = 10, 11, 12
    say @g
    say @h
    say @i
    say :finish
  }

Aliases.say 'Hello Aliases !!!'
Aliases.foo!
Aliases.assert!
p [:attr, :are_public, Aliases.i]
