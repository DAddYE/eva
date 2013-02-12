require 'eventmachine'

# Bad things here, but EM doesn't support include/extend
# in any way know to me
Object.send :remove_const, :Eva if defined?(Eva)
Eva = EventMachine
Eva.send :remove_const, :VERSION

require 'eva/version'
require 'eva/space'
require 'eva/ext/object'
require 'eva/emitter'

module Eva
  extend self
  attr_reader :timers
end
