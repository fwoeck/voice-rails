# Preventing AR from leaking db-connections with Celluloid is actually quite hard.
# Common symptoms of lost connections are:
#
# - Amqp-messaging works but reqular REST requests hang
# - Push-notifications are not being sent to browsers after a while
# - Timeout-errors waiting for a connection from the AR pool
# - Timeouts when receiving RPC-messages
#
# Furthermore, this behavior is not consistent with mri and jruby (see below).
# We may have to find better solutions eventually:
# - Migration to Sequel (hard because of devise, rolify, ...)
# - Isolating AR-requests into a regular thread-pool
# - Skipping Celluloid for Rails
#
# Further reading:
# - http://bibwild.wordpress.com/2014/07/17/activerecord-concurrency-in-rails4-avoid-leaked-connections/
# - https://groups.google.com/forum/#!topic/celluloid-ruby/n9a1RpRztjY
#
if RUBY_PLATFORM == 'java'
  module ActiveRecord
    class Base
      singleton_class.send(:alias_method, :original_connection, :connection)

      def self.connection
        ActiveRecord::Base.connection_pool.with_connection do |conn|
          conn
        end
      end
    end
  end
end
