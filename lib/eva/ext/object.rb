class Object
  include Eva::Space

  [
    :add_periodic_timer, :add_timer, :add_shutdown_hook, :cancel_timer,
    :defer, :defers_finished?, :fork_reactor, :next_tick,
    :popen, :reactor_running?, :reactor_thread?,
    :schedule, :spawn, :system, :tick_loop
  ].each do |name|
    define_method(name) { |*args, &block| Eva.send(name, *args, &block) }
  end

  alias :set_interval   :add_periodic_timer
  alias :set_timeout    :add_timer
  alias :clear_interval :cancel_timer
  alias :clear_timeout  :cancel_timer
end
