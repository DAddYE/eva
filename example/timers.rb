require 'bundler/setup'
require 'eva'

namespace :Timer,
  init: -> {
    @sid = set_interval(1, say_hello)
    set_timeout(4,  quit)
  },
  say_hello: -> {
    puts 'Hello World'
  },
  quit: -> {
    puts 'Bye...'
    clear_interval @sid
  }

puts 'Starting ...'
Timer.init!
