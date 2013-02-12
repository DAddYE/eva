##
# Rif.: http://nodejs.org/api/events.html
#
module Eva
  #
  # A convenience class for object that needs to
  # emit or subscribe events, like servers or files
  #
  objectspace :Emitter,
    #
    # @example:
    #
    #   emitter = Emitter.new
    #   emitter.emit 'connected', user
    #   client.on 'connected', ->(user) { p [:connected, user] }
    #
    initialize: -> do
      @channels = Hash.new { |h, k| h[k] = [] }
      @uid = 0
    end,
    #
    # @example:
    #
    #   callback = ->(stream) { puts 'someone connected' }
    #   server.on 'data', cb
    #   # or
    #   server.on('data') do |stream|
    #     puts 'Someone connected'
    #   end
    #
    on: ->(event, &block) do
      id = gen_id
      @channel[event] << { id => block }
      id
    end,
    #
    # @example:
    #
    #   callback = -> (stream) { puts 'someone connected' }
    #   sid = server.on 'connection', callback
    #   server.off 'connection', callback
    #   # or
    #   server.off 'connection', sid
    #
    off: ->(event, id) do
      @channel[event].delete_if { |k, v| [k, v].include?(id) }
    end,
    #
    # Removes all subscribers of a given event
    #
    off_all: ->(id) do
      @channel[event] = []
    end,
    #
    # @example:
    #
    #   emitter = Emitter.new
    #   emitter.emit 'connected', user
    #
    emit: ->(event, data) do
      next_tick do
        @channel[event].each { |id, block| block[data] }
      end
    end,
    #
    # @private
    _gen_id: -> { @uid += 1 }
end
