require 'sequel'

module Local
  module Sequel
    module DB
      Adapters = {
        'sqlite3' => 'sqlite',
        'postgresql' => 'postgres'
      }

      def rails_db_config
        return nil unless defined?(::Rails)

        c = ::Rails.configuration.database_configuration[::Rails.env]

        {
          adapter: Adapters[c['adapter']] || c['adapter'],
          database: c['database'],
          username: c['username'],
          password: c['password'],
          host: c['host'],
          port: c['port']
        }.delete_if{ |_, v| v.nil? || v === '' }
      end

      def create_table
        db = ::Sequel.connect(ENV['LOCAL_DB_URI'] || rails_db_config)

        db.create_table? :translations do
          primary_key :id

          String :locale
          String :key
          String :value
          String :interpolations
          Boolean :is_proc, default: false
        end
      end

      extend self
    end
  end
end
