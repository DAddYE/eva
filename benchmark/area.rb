require 'bundler/setup'
require 'benchmark'

namespace :Circle,
  area: ->(n) do
    Math::PI * n * n
  end,

  circumference: ->(n) do
    Math::PI * n * 2
  end

TEST = 10_000_000.times.map { rand(100_000..1_000_000) }

Benchmark.bm(15) do |x|
  x.report('area normal:') { TEST.each { |n| Circle.area(n) } }
  x.report('area eva:')   { TEST.each(&Circle.area) }
end

# Results:
#
#   user     system      total        real
#   area normal:     16.940000   0.000000  16.940000 ( 16.947472)
#   area eva:        6.300000   0.000000   6.300000 (  6.306686)
