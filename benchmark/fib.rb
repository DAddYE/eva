require 'bundler/setup'
require 'eva'
require 'benchmark'

namespace :Fib,
  calc: ->(n) do
    n < 2 ? 1 : calc(n-2) + calc(n-1)
  end

Benchmark.measure do
  p Fib.calc(35)
end
