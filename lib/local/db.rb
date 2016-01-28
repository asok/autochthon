require 'sequel'
require 'yaml'

Sequel.extension :core_extensions
Sequel::Model.plugin :json_serializer

module Local
  module DBConfig
    Adapters = {
      'sqlite3' => 'sqlite',
      'postgresql' => 'postgres'
    }

    def rails
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

    def connect_arg
      ENV['LOCAL_DB_URI'] || rails || {adapter: 'postgres', database: 'local'}
    end

    extend self
  end

  DB = Sequel.connect(DBConfig.connect_arg)

  DB.create_table? :translations do
    primary_key :id

    String :locale
    String :key
    String :value
    String :interpolations
    Boolean :is_proc, default: false
  end

  class Translation < Sequel::Model
    plugin :serialization, :yaml, :value
  end
end
