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
